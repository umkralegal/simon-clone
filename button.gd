extends Button


var original_color: Color = self_modulate
onready var tween = Tween.new()

func _ready():
	add_child(tween)

func blink(color: Color):
	self_modulate = Color.white
	tween.interpolate_property(self, "self_modulate", color, original_color, 0.5)
	tween.start()
