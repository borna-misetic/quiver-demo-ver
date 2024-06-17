extends CharacterBody2D

var colliding := false
@export var health := 2
@export var flipped := false

func _ready():
	if flipped:
		$Sprite2D.flip_h = true
		$Marker2D.position = Vector2(-$Marker2D.position.x,0)



func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		colliding = true


func _on_detection_body_exited(body):
	if body.is_in_group("player"):
		colliding = false
