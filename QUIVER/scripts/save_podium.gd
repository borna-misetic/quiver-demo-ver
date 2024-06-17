extends StaticBody2D

signal saveInitiated

@onready var startTime := Time.get_ticks_msec()

func _on_save_area_body_entered(body):
	if Time.get_ticks_msec() - startTime < 1000:
		return
	if body.is_in_group("player"):
		emit_signal("saveInitiated")
