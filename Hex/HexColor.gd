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
