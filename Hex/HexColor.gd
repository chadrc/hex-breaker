class_name HexColor

enum {
	Red,
	Orange,
	Yellow,
	Green,
	Blue,
	Purple
}

const i = .8 	# intensity
const h = i / 2 # half intensity

static func color_for(h):
	match h:
		Red:
			return Color(i, .0, .0, 1.0)
		Orange:
			return Color(i, h, .0, 1.0)
		Yellow:
			return Color(i, i, .0, 1.0)
		Green:
			return Color(.0, i, .0, 1.0)
		Blue:
			return Color(.0, .0, i, 1.0)
		Purple:
			return Color(h, .0, i, 1.0)
			

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
