extends Node

@export var entity : CharacterBody2D
@onready var blinkInterval = $BlinkInterval
@onready var effectLength = $EffectLength

func _blinkEffect(duration) -> void:
	effectLength.wait_time = duration
	blinkInterval.start()
	effectLength.start()

func _on_blink_interval_timeout() -> void:
	entity.visible = !entity.visible

func _on_effect_length_timeout() -> void:
	blinkInterval.stop()
	effectLength.stop()
	entity.visible = true
	entity.collision_layer = 5
