extends KinematicBody

signal ball_hit_player
signal recall_ability_invoked
signal boost_cooldown_tick
signal boost_cooldown_end
signal recall_cooldown_tick
signal recall_cooldown_end

export (int) var ceiling = 200
export (int) var sub_amount = 50
export (float) var speed = 50
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
var physics_translation = null

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
	current_speed = speed
	add_to_group("player")


func _process(delta):
	if start_rotation != null:
		rotation_time += delta
		var frac = rotation_time / rotation_duration
		if frac > 1:
			rotation_degrees.z = target_rotation
			start_rotation = null
			target_rotation = null
			rotation_time = 0
		else:
			rotation_degrees.z = lerp(start_rotation, target_rotation, rotation_time / rotation_duration)
	else:
		if Input.is_action_just_pressed("game_rotate_left"):
			start_rotation = rotation_degrees.z
			target_rotation = rotation_degrees.z + 60
		elif Input.is_action_just_pressed("game_rotate_right"):
			start_rotation = rotation_degrees.z
			target_rotation = rotation_degrees.z - 60
			
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
			print("current %s | speed %s" % [current_speed, speed])
			current_speed = boost_speed
			boosting = true
			boost_on_cooldown = true
	
	if boosting:
		boost_time += delta
		if boost_time >= boost_duration:
			boosting = false
			current_speed = speed
			print("speed %s" % speed)
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
			emit_signal("recall_ability_invoked", translation)
			recall_on_cooldown = true


func _physics_process(delta):
	var v = Vector3(0, 0, 0)
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_action_pressed("ui_left"):
		v.x -= 1
	if Input.is_action_pressed("ui_up"):
		v.y += 1
	if Input.is_action_pressed("ui_down"):
		v.y -= 1
	
	var win_height = ProjectSettings.get_setting("display/window/size/height")
#	var upper_limit = win_height - ceiling
#	var lower_limit = win_height + sub_amount
#	if v.y > 0 and translation.y < upper_limit:
#		v.y = 0
#	elif v.y < 0 and translation.y > lower_limit:
#		v.y = 0

	move_and_slide(v.normalized() * current_speed)


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
	rotation_degrees.z = 0.0
	boosting = false
	
	emit_signal("boost_cooldown_end")
	emit_signal("recall_cooldown_end")
	

func get_color(p):
	var dif = translation - p
	
	var deg
	if dif.x == 0:
		deg = 90.0
	else:
		deg = rad2deg(atan(dif.y / dif.x))
	
	# start off in 2nd quadrant
	# check if were in other three
	if p.x > translation.x and p.y <= translation.y:
		# 1st quadrant
		deg = 180.0 - abs(deg)
	elif p.x <= translation.x and p.y > translation.y:
		# 3rd quadrant
		deg = 360.0 - abs(deg)
	elif p.x > translation.x and p.y > translation.y:
		# 4th quadrant
		deg = 180 + deg
		
	deg = int(deg - rotation_degrees) % 360
	
	var index = floor(deg / 60.0)
	print("deg %s | index %d" % [deg, index])
	return colors[index]
