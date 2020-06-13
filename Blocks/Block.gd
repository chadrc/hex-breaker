extends StaticBody2D

signal destroyed

onready var fill = $'Node2D/Fill'
onready var death_timer = $"Timer"

var color = HexColor.Red
var dead = false

func _ready():
	add_to_group("blocks")
	fill.self_modulate = HexColor.color_for(color)
	

func get_color():
	return color


func set_single_color(c):
	color = c
	if fill:
		fill.self_modulate = HexColor.color_for(color)


func destroy():
	if !dead:
		dead = true
		death_timer.start()


func _on_Timer_timeout():
	queue_free()
	emit_signal("destroyed", self)
