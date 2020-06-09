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
	Piece1.set_color(HexColor.Red)
	Piece2.set_color(HexColor.Orange)
	Piece3.set_color(HexColor.Yellow)
	Piece4.set_color(HexColor.Green)
	Piece5.set_color(HexColor.Blue)
	Piece6.set_color(HexColor.Purple)


func _on_HexPiece_piece_touched(body, color):
	emit_signal("piece_touched", body, color)

