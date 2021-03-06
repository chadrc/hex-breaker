extends CanvasLayer

signal new_game_button_pressed
signal pause
signal unpause
signal restart
signal game_mode_change

onready var Background = $"Background"

onready var PausePanel = $"PausePanel"
onready var GameModeOption = $'PausePanel/GameModeOption'
onready var ContinueButton = $'PausePanel/ContinueButton'

onready var ScorePanel = $"ScorePanel"
onready var ComboLabel = $"ScorePanel/ScoreBoard/ComboLabel"
onready var StreakLabel = $"ScorePanel/ScoreBoard/StreakLabel"
onready var BallsLabel = $"ScorePanel/ScoreBoard/BallsLabel"
onready var TimeLabel = $"ScorePanel/ScoreBoard/TimeLabel"
onready var ScoreLabel = $"ScorePanel/ScoreBoard/ScoreLabel"

var scoring = false
var paused = false

var selected_index = 1
var current_index = 1

func _ready():
	GameModeOption.add_item("1 Color", 1)
	GameModeOption.add_item("2 Color", 2)
	GameModeOption.add_item("3 Color", 3)
	GameModeOption.add_item("6 Color", 6)
	GameModeOption.select(1)
	

func _process(_delta):
	if scoring:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("new_game_button_pressed")
	else:
		if Input.is_action_just_pressed("ui_home"):
			if paused:
				_unpause()
			else:
				paused = true
				Background.visible = true
				PausePanel.visible = true
				emit_signal("pause")
		elif paused and Input.is_action_just_pressed("ui_accept"):
			_unpause()
		elif Input.is_action_just_pressed("ui_end"):
			_restart()


func _on_Game_game_end(data):
	scoring = true
	Background.visible = true
	ScorePanel.visible = true
	
	var time = data.time
	var ms = time % 1000
	var secs = (time - ms) / 1000
	var secs_of_min = secs % 60
	var minutes = secs / 60
	
	ComboLabel.text = "Combo: %d" % data.combo
	StreakLabel.text = "Streak: %d" % data.streak
	BallsLabel.text = "Balls Lost: %d" % data.balls_lost
	TimeLabel.text = "Time: %d:%d.%d" % [minutes, secs_of_min, ms]
	ScoreLabel.text = "Score: %d" % data.score


func _on_Game_game_start(_colors):
	scoring = false
	Background.visible = false
	ScorePanel.visible = false
	PausePanel.visible = false


func _on_NewGameButton_pressed():
	emit_signal("new_game_button_pressed")


func _on_ContinueButton_pressed():
	_unpause()
	

func _on_RestartButton_pressed():
	_restart()


func _unpause():
	paused = false
	Background.visible = false
	PausePanel.visible = false
	emit_signal("unpause")
	

func _restart():
	if selected_index != current_index:
		current_index = selected_index
		emit_signal("game_mode_change", GameModeOption.get_item_id(selected_index))
	emit_signal("restart")


func _on_GameModeOption_item_selected(i):
	selected_index = i
	ContinueButton.disabled = selected_index != current_index
