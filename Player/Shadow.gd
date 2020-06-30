extends KinematicBody

export (float) var life_time = 10.0

onready var visuals = $'Visuals/Hex'

var life_timer = 0

var color = Color(.4, .2, .2, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = visuals.get_surface_material(0)
	color = mat.albedo_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_timer += delta
	
	var c = color
	c.a = 1 - (life_timer / life_time)
	var mat = visuals.get_surface_material(0)
	mat.albedo_color = c
	visuals.set_surface_material(0, mat)
	
	if life_timer >= life_time:
		queue_free()
