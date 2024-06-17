extends Node2D

@onready var animationPlayer = $AnimationPlayer
@onready var menu = preload("res://QUIVER/scenes/menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_mute(1, true)
	animationPlayer.play("scroll")
	await animationPlayer.animation_finished
	get_parent().add_child(menu.instantiate())
	queue_free()

func _process(_delta):
	if Input.is_anything_pressed():
		get_parent().add_child(menu.instantiate())
		queue_free()
