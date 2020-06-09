extends Area2D


signal piece_touched

onready var sprite = $"Sprite"

var color


func set_color(c):
	color = c
	sprite.self_modulate = color


func _on_HexPiece_body_entered(body):
	emit_signal("piece_touched", body, color)
