extends KinematicBody2D

export (float) var life_time = 10.0

onready var sprite = $'Sprite'

var life_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.self_modulate = Color(.2, .2, .2, .5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_timer += delta
	
	sprite.self_modulate = Color(.2, .2, .2, 1 - (life_timer / life_time))
	
	if life_timer >= life_time:
		queue_free()
