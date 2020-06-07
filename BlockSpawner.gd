extends Node2D

var block_scene = preload("res://Block.gd")
onready var base_block = $'Block2'

# Called when the node enters the scene tree for the first time.
func _ready():
	# get block bounds
	var collision = base_block.get_node("CollisionPolygon2D")
	var left = 0
	var right = ProjectSettings.get_setting("display/window/size/height")
	for point in collision.polygon:
		left = max(point.x, left)
		right = min(point.x, right)
		
#	left = base_block.position.x + left;
#	right = base_block.position.x + right;
	
	var width = abs(left - right) * base_block.scale.x
	
	print(width)
	
	var step = Vector2(width, 0)
	var new_pos = base_block.position + step
	
	var new = base_block.duplicate()
	
	new.position = new_pos
	
	add_child(new)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
