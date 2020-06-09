class_name HexColor

enum {
	Red,
	Orange,
	Yellow,
	Green,
	Blue,
	Purple
}

static func color_for(h):
	match h:
		Red:
			return Color.red
		Orange:
			return Color.orange
		Yellow:
			return Color.yellow
		Green:
			return Color.green
		Blue:
			return Color.blue
		Purple:
			return Color.purple
			

static func random_hex_color():
	var roll = rand_range(0, 6) as int
	var color
	match roll:
		0:
			color = Red
		1:
			color = Orange
		2:
			color = Yellow
		3:
			color = Green
		4:
			color = Blue
		5:
			color = Purple
	
	return color
