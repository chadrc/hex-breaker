extends RigidBody

signal destroyed

onready var fill = $'Visuals/Hex'
onready var death_timer = $"DeathTimer"
onready var ball_power_up = $'Visuals/BallPowerUp'
onready var shadow_power_up = $'Visuals/ShadowPowerUp'

var color = HexColor.Red
var dead = false
var has_ball_powerup = false
var has_shadow_powerup = false

func _ready():
	var mat = SpatialMaterial.new()
	mat.albedo_color = HexColor.color_for(color)
	fill.set_surface_material(0, mat)
	
	ball_power_up.visible = has_ball_powerup
	shadow_power_up.visible = has_shadow_powerup
	

func get_color():
	return color


func set_color(c):
	color = c
	if fill:
		var mat = fill.get_surface_material(0)
		mat.albedo_color = HexColor.color_for(color)
		fill.set_surface_material(0, mat)


func destroy():
	if !dead:
		dead = true
		death_timer.start()


func _on_DeathTimer_timeout():
	queue_free()
	emit_signal("destroyed", self)
