extends Area2D

@onready var gameManager = get_parent().get_parent()
@onready var player = gameManager.get_node("Player")

func _ready():
	if MetSys.register_storable_object(self):
		return

func _on_body_entered(body):
	if body.is_in_group("player"):
		MetSys.store_object(self)
		player.normalCapacity[1] += 5
		player.normalCapacity[0] = player.normalCapacity[1]
		player._updateAmmo(player.normalCapacity, gameManager.get_node("HUD/Main/StandardAmmo/StandardAmmoLabel"))
		gameManager.get_node("HUD/Pickup")._pickup("STANDARD ARROWS", "YOUR STANDARD ARROW RESERVES HAVE BEEN UPGRADED BY 5.")
		queue_free()
