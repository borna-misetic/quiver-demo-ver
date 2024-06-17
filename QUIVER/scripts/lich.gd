extends CharacterBody2D

@export var health := 1
@onready var animationTree := $AnimationTree
var pursuing := false

func _process(_delta):
	_updateAnimation()

func _physics_process(_delta):
	move_and_slide()

func _updateAnimation() -> void:
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	if velocity.x != 0 && !pursuing:
		animationTree.set("parameters/conditions/is_walking", true)
		animationTree.set("parameters/conditions/is_running", false)
		animationTree.set("parameters/conditions/is_idle", false)
	elif velocity.x != 0 && pursuing:
		animationTree.set("parameters/conditions/is_walking", false)
		animationTree.set("parameters/conditions/is_running", true)
		animationTree.set("parameters/conditions/is_idle", false)
	else:
		animationTree.set("parameters/conditions/is_walking", false)
		animationTree.set("parameters/conditions/is_running", false)
		animationTree.set("parameters/conditions/is_idle", true)
	
	if health <= 0:
		animationTree.active = false

func _on_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		body._takeDamage()
