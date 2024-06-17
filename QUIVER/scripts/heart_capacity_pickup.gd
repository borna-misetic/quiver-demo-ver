extends Area2D

@onready var gameManager = get_parent().get_parent()
@onready var player = gameManager.get_node("Player")

func _ready():
	if MetSys.register_storable_object(self):
		return

func _on_body_entered(body):
	if body.is_in_group("player"):
		MetSys.store_object(self)
		player.maxHealth += 2
		player.currentHealth = player.maxHealth
		gameManager._renderHearts()
		gameManager.get_node("HUD/Pickup")._pickup("HEALTH CONTAINER", "THE GLISTENING HEART SOOTHS YOUR SOUL. YOUR MAX HEALTH IS INCREASED BY 2.")
		queue_free()

