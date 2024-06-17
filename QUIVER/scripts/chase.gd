extends State
class_name Chase

@export var moveSpeed := 50.0
@export var enemy : CharacterBody2D
var player : CharacterBody2D

func _enterState():
	player = get_tree().get_first_node_in_group("player")
	
func _update(_delta: float):
	if enemy.health <= 0:
		emit_signal("stateTransitioned", self, "Dead")

func _physicsUpdate(_delta: float):
	var direction = enemy.global_position - player.global_position
	if (direction.x < 70 && direction.x > 0) || (direction.x < 0 && direction.x > -70) && !player.isDead:
		enemy.velocity.x = -direction.normalized().x * moveSpeed
	else:
		emit_signal("stateTransitioned", self, "Idle")
