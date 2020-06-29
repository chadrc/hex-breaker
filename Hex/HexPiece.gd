extends MeshInstance

signal piece_touched

var color = HexColor.Red


func _ready():
	var mat = get_surface_material(0)
	mat.albedo_color = HexColor.color_for(color)
	set_surface_material(0, mat)


func set_color(c):
	color = c
	var mat = get_surface_material(0)
	mat.albedo_color = HexColor.color_for(color)
	set_surface_material(0, mat)


func _on_HexPiece_body_entered(body):
	emit_signal("piece_touched", body, color)
