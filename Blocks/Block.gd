extends RigidBody2D

signal destroyed

onready var Hex = $"Hex"

var color = HexColor.Red

func _ready():
	Hex.set_single_color(color)

func set_single_color(c):
	color = c
	if Hex:
		Hex.set_single_color(c)


func _on_Ball_body_entered(body):
	if body == self:
		queue_free()
		emit_signal("destroyed", self)


func _on_Block_body_entered(body):
	if body.name == "Ball":
		print("ball in block", body.color)
