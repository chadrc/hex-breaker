extends Node2D

signal game_start
signal game_end

var playing = false
var balls_lost = 0
var combo = 0
var highest_combo = 0
var highest_streak = 0
var streak = 0
var score = 0
var start_time = 0

onready var GameArea = $'GameArea'

# Called when the node enters the scene tree for the first time.
func _ready():
	_new_game()
	

func _new_game():
	balls_lost = 0
	combo = 0
	streak = 0
	highest_combo = 0
	highest_streak = 0
	score = 0
	start_time = OS.get_ticks_msec()
	playing = true
	
	GameArea.get_tree().paused = false
	emit_signal("game_start")


func _on_GameArea_ball_launched():
	pass


func _on_GameArea_ball_lost():
	balls_lost += 1


func _on_GameArea_ball_hit_player():
	if combo == 0:
		# No blocks hit after hitting player
		# reset streak
		streak = 0
	
	combo = 0


func _on_GameArea_all_blocks_destroyed():
	var time = OS.get_ticks_msec() - start_time
	score -= balls_lost * 11
	# hard code to 5 minutes right now
	# will need to be based on something eventually
	var percent = 1 - clamp(time / (1000 * 60 * 5), 0, 1)
	score += score * percent
	
	get_tree().paused = true
	emit_signal("game_end", {
		"combo": highest_combo,
		"streak": highest_streak,
		"balls_lost": balls_lost,
		"time": time,
		"score": score
	})


func _on_GameArea_block_destroyed():
	if combo == 0:
		# first block hit after hitting player
		# continue streak
		streak += 1
		highest_streak = max(streak, highest_streak)
	
	combo += 1
	highest_combo = max(combo, highest_combo)
	score += 10 * combo * streak


func _on_UI_new_game_button_pressed():
	_new_game()


func _on_UI_unpause():
	get_tree().paused = false
	

func _on_UI_pause():
	get_tree().paused = true
