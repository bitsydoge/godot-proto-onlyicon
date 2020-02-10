extends Sprite

onready var tween = $Tween

var duration = 0.5
var delay = 0.25
func _ready():
	tween.interpolate_property(self, "scale", scale, scale*1.2, duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "scale", scale*1.2, scale, duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT, duration+delay)
	tween.repeat = true
	tween.start()
