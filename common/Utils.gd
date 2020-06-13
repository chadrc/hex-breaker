class_name Utils


static func pick_one_from(options: Array):
	var roll = rand_range(0, options.size())
	return options[roll]
