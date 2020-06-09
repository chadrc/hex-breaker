extends KinematicBody2D

signal ball_hit_player

export (int) var ceiling = 200
export (int) var sub_amount = 50
export (int) var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		
		
func _physics_process(delta):
	var v = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_action_pressed("ui_left"):
		v.x -= 1
	if Input.is_action_pressed("ui_up"):
		v.y -= 1
	if Input.is_action_pressed("ui_down"):
		v.y += 1
	
	var win_height = ProjectSettings.get_setting("display/window/size/height")
	var upper_limit = win_height - ceiling
	var lower_limit = win_height + sub_amount
	if v.y < 0 and position.y < upper_limit:
		v.y = 0
	elif v.y > 0 and position.y > lower_limit:
		v.y = 0
		
	v = move_and_slide(v.normalized() * speed)


func _on_Hex_piece_touched(body, color):
	if body.name == "Ball":
		emit_signal("ball_hit_player")
		body.set_color(color)
		print("hex touched by ball: %s" % color)
