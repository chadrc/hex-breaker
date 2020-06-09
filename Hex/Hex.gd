extends Node2D

signal piece_touched


onready var Piece1 = $"HexPiece1"
onready var Piece2 = $"HexPiece2"
onready var Piece3 = $"HexPiece3"
onready var Piece4 = $"HexPiece4"
onready var Piece5 = $"HexPiece5"
onready var Piece6 = $"HexPiece6"


# Called when the node enters the scene tree for the first time.
func _ready():
	Piece1.set_color(Color.red)
	Piece2.set_color(Color.orange)
	Piece3.set_color(Color.yellow)
	Piece4.set_color(Color.green)
	Piece5.set_color(Color.blue)
	Piece6.set_color(Color.purple)


func _on_HexPiece_piece_touched(body, color):
	emit_signal("piece_touched", body, color)

