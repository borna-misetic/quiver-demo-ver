extends CharacterBody2D

var turretArrow := false
var arrowVelocity := Vector2(0,0)
@export var speed = 300


func _physics_process(delta):
	move_and_collide(arrowVelocity * delta * speed)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if turretArrow:
			body._takeDamage()
		else:
			return
	elif body.is_in_group("enemy"):
		AudioManager._playHit()
		body.health -= 1
	elif body.is_in_group("standard_wall"):
		AudioManager._playHit()
		body._destroy()
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
