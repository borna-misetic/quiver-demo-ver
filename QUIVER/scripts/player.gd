extends CharacterBody2D

@export var moveSpeed := 80.0
@export var jumpPower := 240.0
@export var whitenDuration := 0.15
@export var invincibilityDuration := 1
@export var whitenShader : ShaderMaterial

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var hasBow := false
var hasBooster := false
var jumpCount := 0
var maxJumps := 1
var maxHealth := 2
var currentHealth := 2
var isDead := false
var selectedIndex := 0
var normalCapacity := [0,0]
var upgradedCapacity := [0,0]

@onready var selectIcons := [preload("res://QUIVER/images/wooden-arrow-pickup.png"), preload("res://QUIVER/images/stone-arrow-pickup.png")]
@onready var standardArrowPath = preload("res://QUIVER/scenes/standard_arrow.tscn")
@onready var upgradedArrowPath = preload("res://QUIVER/scenes/upgraded_arrow.tscn")
@onready var animationTree = $AnimationTree
@onready var playerSprite = $Sprite2D
@onready var gameManager = get_parent()

func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	if(!isDead):
		if(Input.is_action_just_pressed("swap")):
			if(upgradedCapacity[1] > 0):
				$Swap.play()
				selectedIndex ^= 1
				get_parent().get_node("HUD/Main/SelectBox/SelectedItem").texture = selectIcons[selectedIndex]
		if(Input.is_action_just_pressed("shoot")):
			_shoot()
		if(!is_on_floor()):
			velocity.y += gravity * delta
		else:
			jumpCount = 0
		if(Input.is_action_just_pressed("jump") && jumpCount < maxJumps):
			$Jump.play()
			velocity.y = -jumpPower
			jumpCount += 1
		velocity.x = 0
		if(Input.is_action_pressed("move_right")):
			velocity.x = moveSpeed
		if(Input.is_action_pressed("move_left")):
			velocity.x = -moveSpeed
		
		move_and_slide()
		_updateAnimation(velocity)
	else:
		$CollisionShape2D.disabled = true
	
@warning_ignore("shadowed_variable_base_class")
func _updateAnimation(velocity) -> void:
	
	if(velocity.x > 0):
		playerSprite.flip_h = false;
		$Marker2D.position.x = 64
	elif(velocity.x < 0):
		playerSprite.flip_h = true
		$Marker2D.position.x = -64
		
	if(!hasBow):
		animationTree.set("parameters/conditions/has_nothing", true)
	elif(hasBow && !hasBooster):
		animationTree.set("parameters/conditions/has_nothing", true)
		animationTree.set("parameters/conditions/has_bow", true)
	elif(hasBooster):
		animationTree.set("parameters/conditions/has_nothing", true)
		animationTree.set("parameters/conditions/has_bow", true)
		animationTree.set("parameters/conditions/has_booster", true);
	
	if(velocity.x != 0):
		animationTree.set("parameters/conditions/is_walking", true);
		animationTree.set("parameters/conditions/idle", false);
	else:
		animationTree.set("parameters/conditions/is_walking", false);
		animationTree.set("parameters/conditions/idle", true);
		
	if(!is_on_floor()):
		animationTree.set("parameters/conditions/jumping", true);
		animationTree.set("parameters/conditions/on_ground", false);
	else:
		animationTree.set("parameters/conditions/jumping", false);
		animationTree.set("parameters/conditions/on_ground", true);

func _shoot() -> void:
	
	# shoots a normal arrow
	if(normalCapacity[0] > 0 && selectedIndex == 0):
		AudioManager._playShoot()
		var standardArrow = standardArrowPath.instantiate()
		get_parent().add_child(standardArrow)
		standardArrow.position = $Marker2D.global_position
		standardArrow.arrowVelocity = Vector2(1,0)
		if(playerSprite.flip_h):
			standardArrow.get_node("Sprite2D").flip_h = true
			standardArrow.arrowVelocity = Vector2(-1,0)
		normalCapacity[0] -= 1
		_updateAmmo(normalCapacity, get_parent().get_node("HUD/Main/StandardAmmo/StandardAmmoLabel"))
	
	# shoots an upgraded arrow
	elif(len(get_tree().get_nodes_in_group("upgraded_arrow")) == 0 && upgradedCapacity[0] > 0 && selectedIndex == 1):
		AudioManager._playShoot()
		var upgradedArrow = upgradedArrowPath.instantiate()
		get_parent().add_child(upgradedArrow)
		upgradedArrow.position = $Marker2D.global_position
		upgradedArrow.arrowVelocity = Vector2(1,0)
		if(playerSprite.flip_h):
			upgradedArrow.get_node("Sprite2D").flip_h = true
			upgradedArrow.arrowVelocity = Vector2(-1,0)
		upgradedCapacity[0] -= 1
		_updateAmmo(upgradedCapacity, get_parent().get_node("HUD/Main/UpgradedAmmo/UpgradedAmmoLabel"))

# could also be done with getters and setters, perhaps something to revisit at a later date
func _updateAmmo(ammoType : Array, label : RichTextLabel) -> void:
	if(ammoType[0] == 0):
		label.text = "[font_size=10][center][color=red]0/" + str(ammoType[1])
	else:
		label.text = "[font_size=10][center][color=white]" + str(ammoType[0]) + "/" + str(ammoType[1])

func _takeDamage() -> void:
	AudioManager._playHit()
	currentHealth -= 1
	get_parent()._renderHearts()
	if currentHealth <= 0:
		_killPlayer()
	else:
		whitenShader.set_shader_parameter("whiten", true)
		await get_tree().create_timer(whitenDuration).timeout
		$Blinker._blinkEffect(invincibilityDuration)
		whitenShader.set_shader_parameter("whiten", false)
		collision_layer = 1

func _killPlayer() -> void:
	if(hasBooster):
		isDead = true
		$AnimationTree.active = false
		$AnimationPlayer.play("death_booster")
		await $AnimationPlayer.animation_finished
		_deathProcedure()
	else:
		isDead = true
		$AnimationTree.active = false
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
		_deathProcedure()

func _deathProcedure() -> void:
	get_tree().root.get_node("GameManager/HUD/Death").visible = true
	get_tree().paused = true
	AudioManager._playDeath()

func _win() -> void:
	get_tree().root.get_node("GameManager/HUD/Victory").visible = true
	get_tree().paused = true
	AudioManager._playWin()
