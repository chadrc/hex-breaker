extends Sprite


export (Color) var color


# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate = color


