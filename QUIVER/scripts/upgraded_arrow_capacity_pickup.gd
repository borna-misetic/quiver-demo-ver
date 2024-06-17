extends Area2D

@onready var gameManager = get_parent().get_parent()
@onready var player = gameManager.get_node("Player")

func _ready():
	if MetSys.register_storable_object(self):
		return

func _on_body_entered(body):
	if body.is_in_group("player"):
		MetSys.store_object(self)
		player.upgradedCapacity[1] += 5
		player.upgradedCapacity[0] = player.upgradedCapacity[1]
		player._updateAmmo(player.upgradedCapacity, gameManager.get_node("HUD/Main/UpgradedAmmo/UpgradedAmmoLabel"))
		gameManager.get_node("HUD/Main/UpgradedAmmo").visible = true
		gameManager.get_node("HUD/Pickup")._pickup("UPGRADED ARROWS", "YOUR UPGRADED ARROW RESERVES HAVE BEEN UPGRADED BY 5.")
		queue_free()
