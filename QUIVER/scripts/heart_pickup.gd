extends Area2D

var insideBody := false

@onready var gameManager = get_tree().root.get_node("GameManager")
@onready var player = gameManager.get_node("Player")

func _process(_delta):
	if insideBody && player.currentHealth != player.maxHealth:
		player.currentHealth += 1
		gameManager._renderHearts()
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		insideBody = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		insideBody = false
