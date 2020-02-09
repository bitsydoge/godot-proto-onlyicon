extends Node

onready var Player = $World/Player
onready var UI = $UI

func _ready():
	Player.AmmoMags.connect("ammo_changed", UI.AmmoCounter, "_on_ammo_changed")
