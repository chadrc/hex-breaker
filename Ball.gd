extends RigidBody2D


export (int) var initial_speed = 250
export (int) var max_speed = 300
export (int) var min_speed = 50

var previous_dir = Vector2(0, 1)
var original_position
var reset = false

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	linear_velocity = previous_dir * initial_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if reset:
		previous_dir = Vector2(0, 1)
		state.transform = Transform2D(0, original_position)
		linear_velocity = previous_dir * initial_speed
		reset = false
		return
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * min_speed
		
	previous_dir = state.linear_velocity.normalized()


func _on_DeathBox_body_entered(body):
	if body == self:
		reset = true


func _on_Ball_body_entered(body):
	print()
	pass # Replace with function body.
