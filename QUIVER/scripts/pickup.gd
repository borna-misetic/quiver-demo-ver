extends Control

var animationFinished = false
var savePrompt = false

signal cursorEnabled
signal cursorDisabled

@onready var animationPlayer = $AnimationPlayer
@onready var pickupTitle = $PickupTitle

func _pickup(title : String, desciption : String) -> void:
	$Item.play()
	pickupTitle.text = "[center]" + title + "[/center]
[center]-----------[/center]

[font_size=10]" + desciption
	visible = true
	get_tree().paused = true
	animationPlayer.play("popup_open")

func _process(_delta):
	if(animationFinished && Input.is_anything_pressed() && !savePrompt):
		animationPlayer.play("popup_close")
		emit_signal("cursorDisabled")
		$SavePrompt.visible = false
		animationFinished = false
		await animationPlayer.animation_finished
		visible = false
		savePrompt = false
		get_tree().paused = false

func _savePrompt() -> void:
	await animationPlayer.animation_finished
	emit_signal("cursorEnabled")
	savePrompt = true
	$SavePrompt.visible = true

func _closePrompt() -> void:
	savePrompt = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "popup_open":
		animationFinished = true

