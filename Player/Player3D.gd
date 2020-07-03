extends KinematicBody

signal recall_ability_invoked
signal boost_cooldown_tick
signal boost_cooldown_end
signal recall_cooldown_tick
signal recall_cooldown_end

export (float) var speed = 50
export (float) var rotation_duration = .1
export (int) var boost_speed = 800
export (float) var boost_duration = .5
export (float) var boost_cooldown = 5
export (float) var recall_cooldown = 15

onready var hex = $'Visuals'

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

	# lock the z axis
	translation = Vector3(translation.x, translation.y, 0.0)
	move_and_slide(v.normalized() * current_speed)


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
	var dif = p - translation
	
	var deg
	if dif.x == 0:
		deg = 90.0
	else:
		deg = abs(rad2deg(atan(dif.y / dif.x)))
	
#	print("p %s | t %s" % [p, translation])
#	print('deg %s' % deg)
	# start off in 2nd quadrant
	# check if were in other three
	if p.x > translation.x and p.y > translation.y:
		deg = 180.0 - deg
	elif p.x < translation.x and p.y > translation.y:
		# 2nd quadrant
		deg = deg
	elif p.x < translation.x and p.y < translation.y:
		# 3rd quadrant
		deg = 360.0 - deg
	elif p.x > translation.x and p.y < translation.y:
		# 4th quadrant
		deg = 180 + deg
		
	deg = int(deg + rotation_degrees.z) % 360
	
	var index = floor(deg / 60.0)
#	print("deg %s | index %d" % [deg, index])
	return colors[index]
