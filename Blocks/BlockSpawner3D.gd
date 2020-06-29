extends Spatial

signal all_blocks_destroyed
signal block_destroyed
signal ball_powerup_obtained
signal shadow_powerup_obtained

export (int) var side_padding = 0
export (int) var top_padding = 0
export (NodePath) var ball_path

# for testing with fewer blocks
# not guaranteed to format correctly 
# only formats one row
export (int) var block_count_override = 0

onready var base_block = $'Block'

var initial_pos
var total_blocks = 0
var blocks_destroyed = 0
var all_blocks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = Vector3(50.0, 85.0, 0.0)
	# disable and hide base block 
	base_block.hide()
	base_block.set_process(false)
	base_block.translation = Vector3(100000, 0, 0)



func _create_board(colors):
	# get block bounds
	var mesh_instance = base_block.get_node("Visuals/Hex")
	var win_width = 100.0
	var win_height = 100.0
	var left = 100000.0
	var right = 0
	var top = 0
	var bottom = 100000.0
	for point in mesh_instance.mesh.get_faces():
		left = min(point.x, left)
		right = max(point.x, right)
		top = max(point.z, top)
		bottom = min(point.z, bottom)
		
#	print("left %s | right %s | top %s | bottom %s" % [left, right, top, bottom])
	
	var block_width = abs(left - right) * base_block.scale.x
	var block_height = abs(bottom - top) * base_block.scale.y
#	print("bwidth %s | bheight %s" % [block_width, block_height])
	# height of rectangle inside hexagon
	var block_inner_height = tan(deg2rad(30)) * (block_width / 2) * 2
	# inner height plus top triangle of hexagon
	var additional_height = block_inner_height + ((block_height - block_inner_height) / 2)
	
	var board_width = 75.0
	var board_height = 40.0
	
#	print("block translation %s" % base_block.translation.y)
#	print("inner height %s | additional %s | boardw %s | boardh %s" % [block_inner_height, additional_height, board_width, board_height])
	
	var block_count = floor(board_width / block_width)
	var row_count = floor(board_height / additional_height)
	
	if block_count_override > 0:
		block_count = block_count_override
		row_count = 1
	
	var first = Vector3(win_width / 2 - block_width * floor(block_count / 2), initial_pos.y, 0.0)
	if int(block_count) % 2 == 0:
		# add half block width so center is between 2 blocks
		# instead of in middle of a single block
		first.x += block_width / 2
	
	var off_block_count = block_count - 1
	if block_count_override > 0:
		off_block_count = 0
	
	var off_first = Vector3(first.x, initial_pos.y, 0.0) + Vector3(1, 0, 0).rotated(Vector3.FORWARD, deg2rad(-60)) * block_width
	
#	print('first %s | off %s' % [first, off_first])
#	print("blocks %s | rows %s" % [block_count, row_count])
	total_blocks = 0
	all_blocks = []
	for r in range(row_count):
		var group = floor(r / 2.0)
		var row_first
		var row_block_count
		var y_offset = block_height * group + block_inner_height * group
		if r % 2 == 0:
			# regular row
			row_first = Vector3(first.x, first.y - y_offset, 0.0)
			row_block_count = block_count
		else:
			# off row
			row_first = Vector3(off_first.x, off_first.y - y_offset, 0.0)
			row_block_count = off_block_count
		
#		print('off %s' % (r % 2))
#		print('row count %s' % row_block_count)
		for i in range(row_block_count):
			# generate block board
			var new_pos = Vector3(row_first.x + block_width * i, row_first.y, 0.0)
			var new = base_block.duplicate()
			
			# hard coded for now, need to convert to input somehow
			var c = Utils.pick_one_from(colors)
			new.set_color(c)
			new.connect("destroyed", self, "_on_block_destroyed")
			new.translation = new_pos
			new.has_ball_powerup = rand_range(0, 100) > 95.0
			new.has_ball_powerup = rand_range(0, 100) > 95.0
			new.has_shadow_powerup = !new.has_ball_powerup and rand_range(0, 100) > 95.0
			
			add_child(new)
			new.visible = true
			all_blocks.append(new)
			total_blocks += 1
		
	# disable and hide base block 
	base_block.hide()
	base_block.set_process(false)
	base_block.translation = Vector3(100000, 0, 0)


func _on_block_destroyed(block):
	blocks_destroyed += 1
	emit_signal("block_destroyed")
	all_blocks.erase(block)
	
	if block.has_ball_powerup:
		emit_signal("ball_powerup_obtained", block)
		
	if block.has_shadow_powerup:
		emit_signal("shadow_powerup_obtained")
	
	if blocks_destroyed == total_blocks:
		emit_signal("all_blocks_destroyed")


func _on_GameArea_reset(colors):
	# make sure all existing blocks dont exist
	for b in all_blocks:
		b.queue_free()
	
	base_block.translation = initial_pos
	base_block.show()
	base_block.set_process(true)
	
	blocks_destroyed = 0
	
	_create_board(colors)
