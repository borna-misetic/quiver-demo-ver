extends Node2D

@onready var animationPlayer = $AnimationPlayer
var game = preload("res://QUIVER/scenes/game_manager.tscn")

func _ready():
	$MenuCursor.enabled = true

func _on_new_game_cursor_selected():
	animationPlayer.play("play")
	$MenuCursor.queue_free()
	await animationPlayer.animation_finished
	var gameInstance = game.instantiate()
	gameInstance.newGame = true
	get_parent().add_child(gameInstance)
	queue_free()

func _on_load_game_cursor_selected():
	animationPlayer.play("play")
	$MenuCursor.queue_free()
	await animationPlayer.animation_finished
	get_parent().add_child(game.instantiate())
	queue_free()

func _on_quit_cursor_selected():
	get_tree().quit()
