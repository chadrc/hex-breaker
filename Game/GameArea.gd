extends Node2D

signal ball_lost
signal ball_launched
signal all_blocks_destroyed
signal block_destroyed
signal ball_hit_player
signal reset
signal stop


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
	

func _stop():
	emit_signal("stop")


func _reset(colors):
	emit_signal("reset", colors)
