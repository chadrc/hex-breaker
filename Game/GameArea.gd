extends Spatial

signal ball_lost
signal ball_launched
signal all_blocks_destroyed
signal block_destroyed
signal ball_hit_player
signal reset
signal stop

const extra_ball_scene = preload("res://Ball/ExtraBall3D.tscn")
const shadow_scene = preload("res://Player/Shadow3D.tscn")

onready var player = $'Player'

func _on_Board_all_blocks_destroyed():
	emit_signal("all_blocks_destroyed")


func _on_Board_block_destroyed():
	emit_signal("block_destroyed")


func _on_Ball_launched():
	emit_signal("ball_launched")


func _on_Ball_lost():
	emit_signal("ball_lost")


func _on_Player_ball_hit_player():
	emit_signal("ball_hit_player")
	

func _stop(_results):
	emit_signal("stop")


func _reset(colors):
	emit_signal("reset", colors)


func _on_Board_ball_powerup_obtained(from_block):
	var new_ball = extra_ball_scene.instance()
	new_ball.name = "PowerUpBall"
	new_ball.translation = from_block.translation
	connect("reset", new_ball, "_on_GameArea_reset")
	connect("stop", new_ball, "_on_GameArea_stop")
	add_child(new_ball)
	new_ball.launch(Vector3.DOWN)


func _on_Board_shadow_powerup_obtained():
	var shadow = shadow_scene.instance()
	shadow.translation = player.translation
	# add to specific container so it renders behind player
	add_child(shadow)
