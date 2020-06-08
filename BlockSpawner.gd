extends Node2D

signal all_blocks_destroyed
signal block_destroyed

export (int) var side_padding = 50
export (int) var top_padding = 50
export (NodePath) var ball_path

# for testing with fewer blocks
# not guaranteed to format correctly 
# only formats one row
export (int) var block_count_override = 0

onready var base_block = $'Block2'

var initial_pos
var total_blocks = 0
var blocks_destroyed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = base_block.position
	# disable and hide base block 
	base_block.hide()
	base_block.set_process(false)
	base_block.position = Vector2(100000, 0)


func _create_board():
	# get block bounds
	var ball = get_node(ball_path)
	var collision = base_block.get_node("CollisionPolygon2D")
	var win_width = ProjectSettings.get_setting("display/window/size/width")
	var win_height= ProjectSettings.get_setting("display/window/size/height")
	var left = 0
	var right = win_width
	var top = 0
	var bottom = win_height
	for point in collision.polygon:
		left = max(point.x, left)
		right = min(point.x, right)
		top = max(point.y, top)
		bottom = min(point.y, bottom)
	
	var block_width = abs(left - right) * base_block.scale.x
	var block_height = abs(bottom - top) * base_block.scale.y
	# height of rectangle inside hexagon
	var block_inner_height = tan(deg2rad(30)) * (block_width / 2) * 2
	# inner height plus top triangle of hexagon
	var additional_height = block_inner_height + ((block_height - block_inner_height) / 2)
	
	var board_width = win_width - side_padding * 2
	var board_height = base_block.position.y - top_padding
	
	var block_count = floor(board_width / block_width)
	var row_count = floor(board_height / additional_height)
	
	if block_count_override > 0:
		block_count = block_count_override
		row_count = 1
	
	var first = Vector2(win_width / 2 - block_width * floor(block_count / 2), base_block.position.y)
	if int(block_count) % 2 == 0:
		# add half block width so center is between 2 blocks
		# instead of in middle of a single block
		first.x += block_width / 2
	
	var off_block_count = block_count - 1
	if block_count_override > 0:
		off_block_count = 0
	
	var off_first = Vector2(first.x, base_block.position.y) + Vector2(1, 0).rotated(deg2rad(-60)) * block_width
	
	total_blocks = 0
	for r in range(row_count):
		var group = floor(r / 2)
		var row_first
		var row_block_count
		var y_offset = block_height * group + block_inner_height * group
		if r % 2 == 0:
			# regular row
			row_first = Vector2(first.x, first.y - y_offset)
			row_block_count = block_count
		else:
			# off row
			row_first = Vector2(off_first.x, off_first.y - y_offset)
			row_block_count = off_block_count
		
		for i in range(row_block_count):
			# generate block board
			var new_pos = Vector2(row_first.x + block_width * i, row_first.y)
			var new = base_block.duplicate()
			ball.connect("body_entered", new, "_on_Ball_body_entered")
			new.connect("destroyed", self, "_on_block_destroyed")
			new.position = new_pos
			
			add_child(new)
			total_blocks += 1
		
	# disable and hide base block 
	base_block.hide()
	base_block.set_process(false)
	base_block.position = Vector2(100000, 0)


func _on_block_destroyed():
	blocks_destroyed += 1
	emit_signal("block_destroyed")
	print("%d / %d" % [blocks_destroyed, total_blocks])
	if blocks_destroyed == total_blocks:
		emit_signal("all_blocks_destroyed")


func _on_Game_game_start():
	base_block.position = initial_pos
	base_block.show()
	base_block.set_process(true)
	
	blocks_destroyed = 0
	
	_create_board()
