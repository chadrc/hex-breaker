extends RigidBody2D

signal launched
signal lost

export (int) var initial_speed = 250
export (int) var max_speed = 300
export (int) var min_speed = 50

onready var BallSprite = $"Sprite"

var previous_dir = Vector2(0, 1)
var original_position
var reset = false
var waiting = true
var color = HexColor.Red
var jitter = false

func set_color(c):
	color = c
	BallSprite.self_modulate = HexColor.color_for(c)

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	linear_velocity = Vector2.ZERO


func _process(_delta):
	if waiting and Input.is_action_pressed("ui_accept"):
		linear_velocity = previous_dir * initial_speed
		waiting = false
		contact_monitor = true
		emit_signal("launched")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	if waiting:
		return;
		
	if reset:
		previous_dir = Vector2(0, 1)
		state.transform = Transform2D(0, original_position)
		linear_velocity = Vector2.ZERO
		reset = false
		waiting = true
		return
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif linear_velocity.length() < min_speed:
		state.linear_velocity = previous_dir * (min_speed + 50)
		
	previous_dir = state.linear_velocity.normalized()


func _on_DeathBox_body_entered(body):
	if body == self:
		reset = true
		emit_signal("lost")


func _on_GameArea_reset():
	reset = true
	

func _on_GameArea_stop():
	contact_monitor = false


func _on_Ball_body_entered(body):
	if body.is_in_group("blocks"):
		if body.get_color() == color:
			body.destroy()
		else:
			# need to jitter movment so don't get stuck in linear bounce
			jitter = true
