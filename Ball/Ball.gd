extends RigidBody2D

signal launched
signal lost
signal energy_update

export (int) var initial_speed = 250
export (int) var max_speed = 300
export (int) var min_speed = 50
export (float) var min_y_velocity = 10.0
export (int) var max_energy = 100
export (float) var energy_per_tick = .5
export (int) var player_energy_loss = 10
export (int) var block_energy_loss = 20

onready var BallSprite = $"Sprite"
onready var energy_timer = $'EnergyTimer'
onready var launch_timer = $'LaunchTimer'

var previous_dir = Vector2(0, 1)
var original_position
var reset = false
var waiting = true
var color = HexColor.Red
var reset_x
var energy = 0
var explode_targets = []
var extra = false

func set_color(c):
	color = c
	BallSprite.self_modulate = HexColor.color_for(c)

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	reset_x = original_position.x
	linear_velocity = Vector2.ZERO
	launch_timer.start()


func _process(_delta):
	if waiting and Input.is_action_pressed("ui_accept"):
		launch_timer.stop()
		launch(previous_dir)
		
		
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if waiting:
		return;
		
	if reset:
		previous_dir = Vector2(0, 1)
		state.transform = Transform2D(0, Vector2(reset_x, original_position.y))
		linear_velocity = Vector2.ZERO
		reset = false
		waiting = true
		_set_energy(0)
		energy_timer.stop()
		launch_timer.start()
		return
	
	var y = state.linear_velocity.y
	if y > -min_y_velocity and y < 0:
		state.linear_velocity.y = -min_y_velocity
	elif y < min_y_velocity and y > 0:
		state.linear_velocity.y = min_y_velocity
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * (min_speed + 50)
		
	previous_dir = state.linear_velocity.normalized()


func _set_energy(amount):
	energy = amount
	emit_signal("energy_update", energy)


func remove_energy(amount):
	_set_energy(max(0, energy - amount))
	

func add_energy(amount):
	_set_energy(min(energy + amount, max_energy))


func _on_DeathBox_body_entered(body):
	if body == self:
		reset = true
		reset_x = original_position.x
		emit_signal("lost")


func _on_GameArea_reset(_colors):
	reset = true
	reset_x = original_position.x
	BallSprite.self_modulate = Color.white
	

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
			reset_x = original_position.x
	elif body.is_in_group("player"):
		set_color(body.get_color(position))
		remove_energy(player_energy_loss)
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
