extends RigidBody2D

export (int) var initial_speed = 250
export (int) var max_speed = 300
export (int) var min_speed = 50
export (float) var min_y_velocity = 10.0

onready var BallSprite = $"Sprite"

var previous_dir = Vector2(0, 1)
var color = HexColor.Red

func set_color(c):
	color = c
	BallSprite.self_modulate = HexColor.color_for(c)


func launch(dir):
	linear_velocity = dir * initial_speed
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	
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


func _on_DeathBox_body_entered(body):
	if body == self:
		queue_free()


func _on_GameArea_reset(_colors):
	queue_free()
	

func _on_GameArea_stop():
	contact_monitor = false


func _on_ExtraBall_body_entered(body):
	if body.is_in_group("blocks"):
		if body.get_color() == color:
			body.destroy()
