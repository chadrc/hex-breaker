extends RigidBody

export (int) var initial_speed = 25
export (int) var max_speed = 40
export (int) var min_speed = 25
export (float) var min_y_velocity = 10.0

onready var visual = $"Visuals/Disk"
onready var change_color_timer = $'ChangeColorTimer'

var previous_dir = Vector3(0, 1, 0)
var color = null

func set_color(c):
	color = c
	var mat = SpatialMaterial.new()
	mat.albedo_color = HexColor.color_for(color)
	visual.set_surface_material(0, mat)


func launch(dir):
	linear_velocity = dir * initial_speed
	contact_monitor = true
	

func _process(_delta):
	if (translation.x <= 0.0 || translation.x >= 100.0
		|| translation.y <= -20.0 || translation.y >= 100.0):
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	
#	var y = state.linear_velocity.y
#	if y > -min_y_velocity and y < 0:
#		state.linear_velocity.y = -min_y_velocity
#	elif y < min_y_velocity and y > 0:
#		state.linear_velocity.y = min_y_velocity
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * (min_speed + 50)
		
	previous_dir = state.linear_velocity.normalized()


func _on_GameArea_reset(_colors):
	queue_free()
	

func _on_GameArea_stop():
	contact_monitor = false


func _on_ExtraBall_body_entered(body):
	if body.is_in_group("blocks"):
		if body.get_color() == color:
			body.destroy()
	if body.is_in_group("balls"):
		if body.name == "Ball": # primary ball
			body.unwait()
	elif body.is_in_group("player"):
		# timer is not active
		if change_color_timer.is_stopped():
			set_color(body.get_color(translation))
			change_color_timer.start()

