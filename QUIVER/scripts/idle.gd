extends State
class_name Idle

@export var enemy: CharacterBody2D
@export var moveSpeed := 30.0
@export var wanderTime := 100
@export var waitTime := 100
@onready var player = get_tree().get_first_node_in_group("player")

const nums := [-1,1]

var moveDirection : Vector2

func _randomizeWander():
	moveDirection = Vector2(nums[randi() % 2], 0)
	wanderTime = 100
	waitTime = 100

func _enterState():
	_randomizeWander()

func _update(delta: float):
	if wanderTime > 0:
		@warning_ignore("narrowing_conversion")
		wanderTime -= delta
	else:
		@warning_ignore("narrowing_conversion")
		waitTime -= delta
		if waitTime <= 0:
			_randomizeWander()
	if enemy.health <= 0:
		emit_signal("stateTransitioned", self, "Dead")

func _physicsUpdate(_delta: float):
	if enemy && wanderTime > 0:
		enemy.velocity = moveDirection * moveSpeed
	else:
		enemy.velocity = Vector2.ZERO
	
	var direction = player.global_position.x - enemy.global_position.x
	if (direction < 40 && direction > 0) || (direction < 0 && direction > -40) && !player.isDead:
		emit_signal("stateTransitioned", self, "Chase")
