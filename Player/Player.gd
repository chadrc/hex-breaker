extends KinematicBody2D

signal ball_hit_player
signal recall_ability_invoked
signal boost_cooldown_tick
signal boost_cooldown_end
signal recall_cooldown_tick
signal recall_cooldown_end

export (int) var ceiling = 200
export (int) var sub_amount = 50
export (int) var speed = 500
export (float) var rotation_duration = .1
export (int) var boost_speed = 800
export (float) var boost_duration = .5
export (float) var boost_cooldown = 5
export (float) var recall_cooldown = 15

onready var hex = $'Hex'

var start_rotation = null
var target_rotation = null
var rotation_time = 0
var current_speed = speed

var colors = []

# Boost ability
var boost_time = 0
var boosting = false
var boost_on_cooldown = false
var boost_cooldown_time = 0

# Recall ability
var recall_on_cooldown = false
var recall_cooldown_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")


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
			
	# Boost Ability
	if boost_on_cooldown:
		boost_cooldown_time += delta
		if boost_cooldown_time >= boost_cooldown:
			boost_on_cooldown = false
			boost_cooldown_time = 0
			emit_signal("boost_cooldown_end")
		else:
			emit_signal("boost_cooldown_tick", boost_cooldown_time, boost_cooldown)
	else:
		if Input.is_action_just_pressed("game_ability_boost"):
			current_speed = boost_speed
			boosting = true
			boost_on_cooldown = true
	
	if boosting:
		boost_time += delta
		if boost_time >= boost_duration:
			boosting = false
			current_speed = speed
			boost_time = 0
			
	# Recall Ability
	if recall_on_cooldown:
		recall_cooldown_time += delta
		if recall_cooldown_time >= recall_cooldown:
			recall_on_cooldown = false
			recall_cooldown_time = 0
			emit_signal("recall_cooldown_end")
		else:
			emit_signal("recall_cooldown_tick", recall_cooldown_time, recall_cooldown)
	else:
		if Input.is_action_just_pressed("game_ability_recall"):
			emit_signal("recall_ability_invoked", position)
			recall_on_cooldown = true

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
		
	v = move_and_slide(v.normalized() * current_speed)


func _on_Hex_piece_touched(body, color):
	if body.is_in_group("balls"):
		emit_signal("ball_hit_player")


func _on_GameArea_reset(c):
	colors = c
	hex.set_colors(colors)
	boost_cooldown_time = 0
	recall_cooldown_time = 0
	boost_on_cooldown = false
	recall_on_cooldown = false
	boost_time = 0
	rotation_degrees = 0.0
	boosting = false
	
	emit_signal("boost_cooldown_end")
	emit_signal("recall_cooldown_end")
	

func get_color(p):
	var dif = p - position
	print("theirs %s | mine %s | dif %s" % [p, position, dif])
	
	var theta
	var d
	if dif.x == 0:
		theta = 90
		d = 0
	else:
		theta = rad2deg(atan(dif.y / dif.x))
		d = dif.normalized().dot(Vector2.LEFT)
		
	var ratio = (d + 1) / 2
	var deg = lerp(180, 0, ratio)
	
	# ball is below player
	if p.y > position.y:
		deg = 360 - deg
		
	deg = int(deg + rotation_degrees) % 360
	
	var index = floor(deg / 60.0)
	print("deg %s | cross %s | index %d" % [deg, d, index])
	return colors[index]
