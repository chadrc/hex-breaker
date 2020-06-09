extends Area2D

signal piece_touched

onready var sprite = $"Sprite"

var color = HexColor.Red


func _ready():
	sprite.self_modulate = HexColor.color_for(color)


func set_color(c):
	color = c
	if sprite:
		sprite.self_modulate = HexColor.color_for(c)


func _on_HexPiece_body_entered(body):
	emit_signal("piece_touched", body, color)
