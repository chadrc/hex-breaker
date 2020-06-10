extends StaticBody2D

signal destroyed

onready var Hex = $"Hex"

var color = HexColor.Red


func _ready():
	add_to_group("blocks")
	Hex.set_single_color(color)
	

func get_color():
	return color


func set_single_color(c):
	color = c
	if Hex:
		Hex.set_single_color(c)


func destroy():
	queue_free()
	emit_signal("destroyed", self)

