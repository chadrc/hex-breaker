extends KinematicBody2D

signal ball_hit_player

export (int) var ceiling = 200
export (int) var sub_amount = 50
export (int) var speed = 500
export (float) var rotation_duration = 1

var start_rotation = null
var target_rotation = null
var rotation_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if start_rotation != null:
		rotation_time += delta
		var frac = rotation_time / rotation_duration
		if frac > 1:
			rotation_degrees = target_rotation
			start_rotation = null
			target_rotation = null
			rotation_time = 0
		else:
			rotation_degrees = lerp(start_rotation, target_rotation, rotation_time / rotation_duration)
	else:
		if Input.is_action_just_pressed("game_rotate_left"):
			start_rotation = rotation_degrees
			target_rotation = rotation_degrees + 60
		elif Input.is_action_just_pressed("game_rotate_right"):
			start_rotation = rotation_degrees
			target_rotation = rotation_degrees - 60


func _physics_process(_delta):
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
