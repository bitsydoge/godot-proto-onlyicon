extends Node2D

var lifespan = 1.5
var is_dead : bool = false

func _process(delta):
	lifespan -= delta
	if lifespan <= 0.0 and not is_dead:
		die()
		
func die():
	is_dead = true
	queue_free()
