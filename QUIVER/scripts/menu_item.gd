extends Node

signal cursorSelected

func _cursorSelect() -> void:
	emit_signal("cursorSelected")
