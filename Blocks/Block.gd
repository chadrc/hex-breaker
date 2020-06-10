extends StaticBody2D

signal destroyed

onready var Hex = $"Hex"
onready var death_timer = $"Timer"

var color = HexColor.Red
var dead = false

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
	if !dead:
		dead = true
		death_timer.start()


func _on_Timer_timeout():
	queue_free()
	emit_signal("destroyed", self)
