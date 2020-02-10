extends KinematicBody2D

onready var AmmoMags = $AmmoMags

export (int) var move_speed := 500
export (int) var run_speed := 725

export (int, 0, 200) var inertia_idle = 50
export (int, 0, 200) var inertia_walking = 75
export (int, 0, 200) var inertia_running = 110

export (float) var friction := 0.08
export (float) var acceleration := 0.025

# Internal Value
var current_speed := 0
var velocity := Vector2()

var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2.ZERO

var is_walking := false
var is_running := false

func get_input():
	# Reset
	direction = Vector2.ZERO
	#velocity.x = 0
	is_walking = false
	is_running = false
	
	######################
	## Button Process
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
		is_walking = true
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
		is_walking = true
	if Input.is_action_pressed('ui_up'):
		direction.y -= 1
		is_walking = true
	if Input.is_action_pressed('ui_down'):
		direction.y += 1
		is_walking = true
		
	if Input.is_action_pressed("ui_run"):
		current_speed = run_speed
		if is_walking == true:
			is_running = true
			is_walking = false
	else:
		current_speed = move_speed

	
	if direction != Vector2.ZERO:
		last_direction = direction

func move():
	if direction != Vector2.ZERO:
		velocity = lerp(velocity, direction * current_speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

func _process(delta):
	get_input()
	move()
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	rigid_body_collid()
	
func rigid_body_collid():
	for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider != null:
				if collision.collider.is_in_group("can_move"):
					if is_walking:
						collision.collider.apply_central_impulse(-collision.normal * inertia_walking)
					elif is_running:
						collision.collider.apply_central_impulse(-collision.normal * inertia_running)
					else:
						collision.collider.apply_central_impulse(-collision.normal * inertia_idle)
