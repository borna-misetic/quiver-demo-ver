extends State
class_name TurretFiring

@export var cooldown := 0.5
@export var enemy : CharacterBody2D
@export var detectionArea : Area2D
@export var marker : Marker2D
@onready var animationPlayer = enemy.get_node("AnimationPlayer")
@onready var standardArrowPath = preload("res://QUIVER/scenes/standard_arrow.tscn")

func _enterState():
	animationPlayer.play("detected")

func _update(delta : float):
	cooldown -= delta
	if cooldown <= 0:
		var standardArrow = standardArrowPath.instantiate()
		standardArrow.turretArrow = true
		standardArrow.position = marker.global_position
		if(enemy.flipped):
			standardArrow.arrowVelocity = Vector2(-1,0)
			standardArrow.get_node("Sprite2D").flip_h = true
		else:
			standardArrow.arrowVelocity = Vector2(1,0)
		add_child(standardArrow)
		AudioManager._playShoot()
		cooldown = 1.0
	if !(enemy.colliding):
		emit_signal("stateTransitioned", self, "TurretStandby")
	if enemy.health <= 0:
		emit_signal("stateTransitioned", self, "Dead")
