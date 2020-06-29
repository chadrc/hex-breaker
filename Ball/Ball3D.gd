extends RigidBody

signal launched
signal lost
signal energy_update

export (int) var initial_speed = 25
export (int) var max_speed = 60
export (int) var min_speed = 15
export (float) var min_y_velocity = 10.0
export (int) var max_energy = 100
export (float) var energy_per_tick = .5
export (int) var player_energy_loss = 10
export (int) var block_energy_loss = 20

onready var ball = $"Visuals/Disk"
onready var energy_timer = $'EnergyTimer'
onready var launch_timer = $'LaunchTimer'
onready var change_color_timer = $'ChangeColorTimer'

var previous_dir = Vector3(0, -1, 0)
var original_translation
var reset = false
var waiting = true
var color = HexColor.Red
var reset_x
var energy = 0
var explode_targets = []
var extra = false

func set_color(c):
	color = c
	var mat = ball.get_surface_material(0)
	mat.albedo_color = HexColor.color_for(color)
	ball.set_surface_material(0, mat)
		
		
func launch(dir):
	linear_velocity = dir * initial_speed
	unwait()


func unwait():
	waiting = false
	reset = false
	contact_monitor = true
	if !extra:
		energy_timer.start()
		emit_signal("launched")

# Called when the node enters the scene tree for the first time.
func _ready():
	original_translation = translation
	reset_x = original_translation.x
	linear_velocity = Vector3.ZERO
	launch_timer.start()


func _process(_delta):
	if waiting and Input.is_action_pressed("ui_accept"):
		launch_timer.stop()
		launch(previous_dir)
		
	if (translation.x <= 0.0 || translation.x >= 100.0
		|| translation.y <= -20.0 || translation.y >= 100.0):
		print("lost")
		reset = true
		reset_x = original_translation.x
		emit_signal("lost")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if reset:
		print("resetting")
		previous_dir = Vector3(0, -1, 0)
		state.transform = Transform2D(0, Vector2(reset_x, original_translation.y))
		linear_velocity = Vector3.ZERO
		reset = false
		waiting = true
		_set_energy(0)
		energy_timer.stop()
		launch_timer.start()
		return
	
	if waiting:
		return;
	
	# might not need with move to 3D
#	var y = state.linear_velocity.y
#	if y > -min_y_velocity and y < 0:
#		state.linear_velocity.y = -min_y_velocity
#	elif y < min_y_velocity and y > 0:
#		state.linear_velocity.y = min_y_velocity
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * (min_speed + min_speed)
#
	previous_dir = state.linear_velocity.normalized()


func _set_energy(amount):
	energy = amount
	emit_signal("energy_update", energy)


func remove_energy(amount):
	_set_energy(max(0, energy - amount))
	

func add_energy(amount):
	_set_energy(min(energy + amount, max_energy))


func _on_GameArea_reset(_colors):
	reset = true
	reset_x = original_translation.x
	ball.self_modulate = Color.white
	

func _on_GameArea_stop():
	contact_monitor = false


func _on_Ball_body_entered(body):
	if body.is_in_group("blocks"):
		if body.get_color() == color:
			body.destroy()
			remove_energy(block_energy_loss)
		elif energy == max_energy:
			for t in explode_targets:
				t.destroy()
			reset = true
			reset_x = original_translation.x
	elif body.is_in_group("player"):
		# timer is not active
		if change_color_timer.is_stopped():
			set_color(body.get_color(translation))
			remove_energy(player_energy_loss)
			change_color_timer.start()
	elif body.is_in_group("balls"):
		# transfer color
		pass
		

func _on_Player_recall_ability_invoked(player_pos):
	if !waiting:
		reset = true
		reset_x = player_pos.x


func _on_EnergyTimer_timeout():
	add_energy(energy_per_tick)


func _on_ExplodeArea_body_entered(body):
	if body.is_in_group("blocks"):
		explode_targets.append(body)


func _on_ExplodeArea_body_exited(body):
	explode_targets.erase(body)


func _on_LaunchTimer_timeout():
	launch(previous_dir)


func _on_ChangeColorTimer_timeout():
	change_color_timer.stop()
