extends Node2D

export (int) var side_padding = 100
export (NodePath) var ball_path

onready var base_block = $'Block2'

var initial_y

# Called when the node enters the scene tree for the first time.
func _ready():
	# get block bounds
	var ball = get_node(ball_path)
	initial_y = base_block.position.y
	var collision = base_block.get_node("CollisionPolygon2D")
	var win_width = ProjectSettings.get_setting("display/window/size/width")
	var left = 0
	var right = win_width
	for point in collision.polygon:
		left = max(point.x, left)
		right = min(point.x, right)
	
	var block_width = abs(left - right) * base_block.scale.x
	var board_width = win_width - side_padding * 2
	var block_count = floor(board_width / block_width)
	var first_x = (win_width / 2 - block_width * floor(block_count / 2))
	if int(block_count) % 2 == 0:
		# add half block width so center is between 2 blocks
		# instead of in middle of a single block
		first_x += block_width / 2
	
	
	for i in range(block_count):
		# generate block board
		var new_pos = Vector2(first_x + block_width * i, base_block.position.y)
		var new = base_block.duplicate()
		ball.connect("body_entered", new, "_on_Ball_body_entered")
		new.position = new_pos
		
		add_child(new)
		
	# disable and hide base block 
	base_block.hide()
	base_block.set_process(false)
	base_block.position = Vector2(100000, 0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
