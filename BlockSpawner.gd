extends Node2D

onready var base_block = $'Block2'
export (NodePath) var ball_path

# Called when the node enters the scene tree for the first time.
func _ready():
	# get block bounds
	var ball = get_node(ball_path)
	var collision = base_block.get_node("CollisionPolygon2D")
	var left = 0
	var right = ProjectSettings.get_setting("display/window/size/height")
	for point in collision.polygon:
		left = max(point.x, left)
		right = min(point.x, right)
	
	var width = abs(left - right) * base_block.scale.x
	
	print(width)
	
	var step = Vector2(width, 0)
	var new_pos = base_block.position + step
	
	var new = base_block.duplicate()
	ball.connect("body_entered", new, "_on_Ball_body_entered")
	new.position = new_pos
	
	add_child(new)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
