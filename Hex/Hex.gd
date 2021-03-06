extends Node2D

signal piece_touched

onready var Piece1 = $"HexPiece1"
onready var Piece2 = $"HexPiece2"
onready var Piece3 = $"HexPiece3"
onready var Piece4 = $"HexPiece4"
onready var Piece5 = $"HexPiece5"
onready var Piece6 = $"HexPiece6"


func set_single_color(c):
	Piece1.set_color(c)
	Piece2.set_color(c)
	Piece3.set_color(c)
	Piece4.set_color(c)
	Piece5.set_color(c)
	Piece6.set_color(c)


func set_two_colors(c1, c2):
	Piece1.set_color(c1)
	Piece2.set_color(c2)
	Piece3.set_color(c1)
	Piece4.set_color(c2)
	Piece5.set_color(c1)
	Piece6.set_color(c2)
	
	
func set_three_colors(c1, c2, c3):
	Piece1.set_color(c1)
	Piece2.set_color(c2)
	Piece3.set_color(c3)
	Piece4.set_color(c1)
	Piece5.set_color(c2)
	Piece6.set_color(c3)


func set_six_colors():
	Piece1.set_color(HexColor.Red)
	Piece2.set_color(HexColor.Orange)
	Piece3.set_color(HexColor.Yellow)
	Piece4.set_color(HexColor.Green)
	Piece5.set_color(HexColor.Blue)
	Piece6.set_color(HexColor.Purple)
	

func set_colors(colors: Array):
	Piece1.set_color(colors[0])
	Piece2.set_color(colors[1])
	Piece3.set_color(colors[2])
	Piece4.set_color(colors[3])
	Piece5.set_color(colors[4])
	Piece6.set_color(colors[5])


func _on_HexPiece_piece_touched(body, c):
	emit_signal("piece_touched", body, c)

