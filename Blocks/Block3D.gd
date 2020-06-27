extends StaticBody

signal destroyed

onready var fill = $'Visuals/Hex'
onready var death_timer = $"Timer"
onready var ball_power_up = $'Visuals/BallPowerUp'
onready var shadow_power_up = $'Visuals/ShadowPowerUp'

var color = HexColor.Red
var dead = false
var has_ball_powerup = false
var has_shadow_powerup = false

func _ready():
	add_to_group("blocks")
	var mat = fill.get_surface_material(0)
	mat.albedo_color = HexColor.color_for(HexColor.Blue)
	print(mat.albedo_color)
	fill.set_surface_material(0, mat)
	
	ball_power_up.visible = has_ball_powerup
	shadow_power_up.visible = has_shadow_powerup
	

func get_color():
	return color


func set_single_color(c):
	color = c
	if fill:
		fill.mesh.surface_get_material(0).albedo_color = HexColor.color_for(color)


func destroy():
	if !dead:
		dead = true
		death_timer.start()


func _on_Timer_timeout():
	queue_free()
	emit_signal("destroyed", self)
