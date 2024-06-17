extends Area2D

var insideBody := false

@onready var gameManager = get_tree().root.get_node("GameManager")
@onready var player = gameManager.get_node("Player")

func _process(_delta):
	if insideBody && player.normalCapacity[0] != player.normalCapacity[1]:
		player.normalCapacity[0] += 1
		player._updateAmmo(player.normalCapacity, gameManager.get_node("HUD/Main/StandardAmmo/StandardAmmoLabel"))
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		insideBody = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		insideBody = false
