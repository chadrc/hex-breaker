extends CanvasLayer

signal new_game_button_pressed

onready var Background = $"Background"
onready var ScorePanel = $"Panel"
onready var ComboLabel = $"Panel/ScoreBoard/ComboLabel"
onready var StreakLabel = $"Panel/ScoreBoard/StreakLabel"
onready var BallsLabel = $"Panel/ScoreBoard/BallsLabel"
onready var TimeLabel = $"Panel/ScoreBoard/TimeLabel"
onready var ScoreLabel = $"Panel/ScoreBoard/ScoreLabel"

var check_input = false

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if check_input and Input.is_action_pressed("ui_accept"):
		emit_signal("new_game_button_pressed")


func _on_Game_game_end(data):
	check_input = true
	Background.visible = true
	ScorePanel.visible = true
	
	var time = data.time
	var ms = time % 1000
	var secs = (time - ms) / 1000
	var minutes = secs / 60
	
	ComboLabel.text = "Combo: %d" % data.combo
	StreakLabel.text = "Streak: %d" % data.streak
	BallsLabel.text = "Balls Lost: %d" % data.balls_lost
	TimeLabel.text = "Time: %d:%d.%d" % [minutes, secs, ms]
	ScoreLabel.text = "Score: %d" % data.score


func _on_Game_game_start():
	check_input = false
	Background.visible = false
	ScorePanel.visible = false


func _on_NewGameButton_pressed():
	emit_signal("new_game_button_pressed")
