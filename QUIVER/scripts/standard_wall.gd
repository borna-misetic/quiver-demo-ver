extends StaticBody2D

func _ready():
	if MetSys.register_storable_object(self):
		return

func _destroy():
	MetSys.store_object(self)
	queue_free()
