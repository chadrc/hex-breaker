extends KinematicBody2D

onready var sprite = $'Sprite'


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.self_modulate = Color(.2, .2, .2, .5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
