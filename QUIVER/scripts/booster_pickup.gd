extends Area2D

@onready var gameManager = get_parent().get_parent()
@onready var player = gameManager.get_node("Player")

func _ready():
	if MetSys.register_storable_object(self):
		return

func _on_body_entered(body):
	if body.is_in_group("player"):
		MetSys.store_object(self)
		player.hasBooster = true
		player.maxJumps = 2
		gameManager.get_node("HUD/Pickup")._pickup("BOOSTER", "A SPECIAL-MADE BOOSTER STRAP. ALLOWS YOU TO JUMP TWICE.")
		queue_free()
