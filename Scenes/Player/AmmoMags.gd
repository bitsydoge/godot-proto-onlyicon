extends Position2D

signal ammo_changed(value)

## SCENES
################
var ammo_scene = preload("res://Scenes/Ammo/Ammo.tscn")
var target_scene = preload("res://Scenes/Target/Target.tscn")

## AMMO
################
var array_ammo = []
const ammo_max = 100
var ammo_cur = 0

## TIMERS
################
const timer_reload = 0.05
var cur_timer_reload = 0.0

const timer_shoot_last = 2.0
var cur_timer_shoot_last = 0.0

const timer_attack_speed = 0.015
var cur_timer_attack_speed = 0.0

## WORLD
################
onready var world = $"../.."

########################################

func add_ammo(x):
	if ammo_cur + x > ammo_max:
		x = ammo_max - ammo_cur
		
	for i in range(x):
		var inst = ammo_scene.instance()
		add_child(inst)
		inst.register_magazine(self)
		array_ammo.push_back(inst)
		ammo_cur+=1
		
	emit_signal("ammo_changed", ammo_cur)

func _ready():
	call_deferred("add_ammo", ammo_max)
		
func _process(delta):
	cur_timer_reload += delta
	cur_timer_shoot_last += delta
	cur_timer_attack_speed += delta
	
	rotation_degrees -= 180 * delta
	
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)) and cur_timer_attack_speed >= timer_attack_speed:
		cur_timer_attack_speed = 0.0
		shoot()
		
	if cur_timer_reload >= timer_reload && cur_timer_shoot_last >= timer_shoot_last:
		cur_timer_reload = 0.0
		add_ammo(1)

func shoot():
	if array_ammo.size() > 0:
		var pos_save = array_ammo[-1].global_position
		remove_child(array_ammo[-1])
		world.add_child(array_ammo[-1])
		
		array_ammo[-1].global_position = pos_save
		array_ammo[-1].add_dest(get_global_mouse_position())
		array_ammo.pop_back()
		ammo_cur-=1
		var target_inst = target_scene.instance()
		world.add_child(target_inst)
		target_inst.global_position = get_global_mouse_position()
		emit_signal("ammo_changed", ammo_cur)
		cur_timer_shoot_last = 0.0
