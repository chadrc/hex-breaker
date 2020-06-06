extends KinematicBody2D


export (int) var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		
		
func _physics_process(delta):
	var v = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_action_pressed("ui_left"):
		v.x -= 1
	if Input.is_action_pressed("ui_up"):
		v.y -= 1
	if Input.is_action_pressed("ui_down"):
		v.y += 1
		
	v = move_and_slide(v.normalized() * speed)
