extends RigidBody2D


export (int) var initial_speed = 250
export (int) var max_speed = 300
export (int) var min_speed = 50

var previous_dir = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = previous_dir * initial_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * min_speed
		
	previous_dir = state.linear_velocity.normalized()
