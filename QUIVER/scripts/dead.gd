extends State
class_name Dead

var i = 0
var itemPool : Array
@export var enemy: CharacterBody2D
@export var hurtbox : Area2D
@onready var gameManager = get_tree().root.get_node("GameManager")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animationPlayer = enemy.get_node("AnimationPlayer")
@onready var collision = enemy.get_node("CollisionShape2D")
@onready var healthPickup = preload("res://QUIVER/scenes/heart_pickup.tscn")
@onready var standardArrowPickup = preload("res://QUIVER/scenes/standard_arrow_pickup.tscn")
@onready var upgradedArrowPickup = preload("res://QUIVER/scenes/upgraded_arrow_pickup.tscn")

func _enterState():
	@warning_ignore("unassigned_variable")
	var positions : Array
	if hurtbox != null:
		hurtbox.monitoring = false
	for child in enemy.get_children():
		if child.is_in_group("drop"):
			positions.append(child)
	_generateItemPool()
	enemy.velocity = Vector2.ZERO
	collision.queue_free()
	animationPlayer.play("death")
	await animationPlayer.animation_finished
	for currentPosition in positions:
		if randf() <= 0.7 && len(itemPool) > 0:
			var item = itemPool[randi() % len(itemPool)].instantiate()
			item.position = currentPosition.position + enemy.position
			gameManager.add_child(item)
	enemy.queue_free()

func _generateItemPool() -> void:
	if(player.currentHealth != player.maxHealth):
		itemPool.append(healthPickup)
	if(player.normalCapacity[0] != player.normalCapacity[1]):
		itemPool.append(standardArrowPickup)
	if(player.upgradedCapacity[0] != player.upgradedCapacity[1]):
		itemPool.append(upgradedArrowPickup)
