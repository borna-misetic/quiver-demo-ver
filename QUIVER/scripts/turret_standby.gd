extends State
class_name TurretStandby

@export var enemy : CharacterBody2D
@export var detectionArea : Area2D
@onready var animationPlayer = enemy.get_node("AnimationPlayer")

func _enterState():
	animationPlayer.play("idle")

func _update(_delta : float):
	if enemy.colliding:
		emit_signal("stateTransitioned", self, "TurretFiring")
	if enemy.health <= 0:
		emit_signal("stateTransitioned", self, "Dead")
