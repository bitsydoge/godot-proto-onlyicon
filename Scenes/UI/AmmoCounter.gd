extends Label

var current_ammo

func _on_ammo_changed(new_value):
	text = "Ammo : " + str(new_value) + "/100"
