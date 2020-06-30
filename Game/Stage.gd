extends Camera

onready var left_border = $'Borders/Left'
onready var right_border = $'Borders/Right'

func _ready():
	var width = size * (get_viewport().size.x / get_viewport().size.y)
	var p = left_border.shape.extents.x / 2
	var margin = (size - width) / 2
	var left = margin + p
	var right = size - margin - p
	left_border.translation.x = left
	right_border.translation.x = right

