extends Node


func _playAmbient():
	$Rain.play()

func _playHit():
	$Hit.play()

func _playShoot():
	$Shoot.play()

func _playDeath():
	AudioServer.set_bus_mute(1, true)
	$Death.play()
	await $Death.finished
	get_tree().root.get_node("GameManager").queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://QUIVER/scenes/intro.tscn")
	
func _playWin():
	AudioServer.set_bus_mute(1, true)
	$Win.play()
	await $Win.finished
	get_tree().root.get_node("GameManager").queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://QUIVER/scenes/intro.tscn")
