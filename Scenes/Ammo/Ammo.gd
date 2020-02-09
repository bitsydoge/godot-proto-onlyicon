extends Node2D

var min_ray = 80
var max_ray = 120

var have_destination : bool = false
var destination : Vector2
var direction
var speed = 720

var rotation_lock = 0

var lifespan = 1.5

onready var tween = $Tween

func prepare_tween():
	tween.interpolate_property(self, "scale:x", scale.x, scale.x*2, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale:y", scale.y, scale.y*2, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	tween.interpolate_property(self, "scale:x", scale.x, 0, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.5)
	tween.interpolate_property(self, "scale:y", scale.y, 0, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.5)

func _ready():
	modulate.r = rand_range(0.96,1.0)
	modulate.g = rand_range(0.84, 0.89)
	modulate.b = rand_range(0.0,0.05)
	var scale_rand = rand_range(0.6,0.8)
	scale.x = scale_rand
	scale.y = scale_rand
	var ray = rand_range(min_ray, max_ray)
	var rot = rand_range(0, 2*PI)
	position = polar2cartesian(ray, rot)
	
	"""
	var x_neg = randi()%2
	var y_neg = randi()%2
	position.x = rand_range(50, 100)
	position.y = rand_range(50, 100)
	print(x_neg)
	print(y_neg)
	if x_neg:
		position.x = -position.x
	if y_neg:
		position.y = -position.y
	"""
	
func _process(delta):
	global_rotation_degrees = rotation_lock
	if have_destination:
		move(delta)
		if lifespan <= 0.0 or global_position.distance_to(destination) <= 5:
			explode()
			
func move(delta):
	lifespan -= delta
	var velocity = direction * speed * delta
	global_position += velocity
	
func explode():
	scale.x = scale.y
	have_destination = false
	prepare_tween()
	tween.start()
	
func add_dest(dest : Vector2):
	destination = dest
	have_destination = true
	direction = (destination - get_position()).normalized()
	rotation_lock = rad2deg(direction.angle())+90
	scale.x = scale.x/1.44


func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.
