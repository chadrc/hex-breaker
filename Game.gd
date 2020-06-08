extends Node2D


var playing = false
var balls_lost = 0
var combo = 0
var highest_combo = 0
var highest_streak = 0
var streak = 0
var score = 0
var start_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _new_game():
	balls_lost = 0
	combo = 0
	streak = 0
	highest_combo = 0
	highest_streak = 0
	score = 0
	start_time = OS.get_ticks_msec()
	playing = true


func _on_Ball_launched():
	if !playing:
		_new_game()


func _on_Ball_lost():
	balls_lost += 1


func _on_Player_ball_hit_player():
	if combo == 0:
		# No blocks hit after hitting player
		# reset streak
		streak = 0
	
	combo = 0


func _on_Board_all_blocks_destroyed():
	var time = OS.get_ticks_msec() - start_time
	var ms = time % 1000
	var secs = (time - ms) / 1000
	var minutes = secs / 60
	
	score -= balls_lost * 11
	# hard code to 5 minutes right now
	# will need to be based on something eventually
	var percent = 1 - clamp(time / (1000 * 60 * 5), 0, 1)
	score += score * percent
	
	print("combo:      ", highest_combo)
	print("streak:     ", highest_streak)
	print("balls lost: ", balls_lost)
	print("time:       %d:%s.%s" % [minutes, secs, ms])
	print("score:      ", score)


func _on_Board_block_destroyed():
	if combo == 0:
		# first block hit after hitting player
		# continue streak
		streak += 1
		highest_streak = max(streak, highest_streak)
	
	combo += 1
	highest_combo = max(combo, highest_combo)
	score += 10 * combo * streak
