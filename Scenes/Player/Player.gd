extends Node2D

var speed = 500

onready var AmmoMags = $AmmoMags

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		global_position.x -= speed * delta
	if Input.is_action_pressed("ui_right"):
		global_position.x += speed * delta
	if Input.is_action_pressed("ui_up"):
		global_position.y -= speed * delta
	if Input.is_action_pressed("ui_down"):
		global_position.y += speed * delta
