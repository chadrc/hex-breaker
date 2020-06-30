extends CanvasLayer


onready var BoostCooldownText = $'CooldownPanel/BoostCooldownText'
onready var RecallCooldownText = $'CooldownPanel/RecallCooldownText'

# Called when the node enters the scene tree for the first time.
func _ready():
	BoostCooldownText.text = "Boost: Ready"
	RecallCooldownText.text = "Recall: Ready"


func _on_Player_boost_cooldown_tick(time, total):
	var time_left = total - time
	BoostCooldownText.text = "Boost: %2.1f" % time_left


func _on_Player_boost_cooldown_end():
	BoostCooldownText.text = "Boost: Ready"


func _on_Player_recall_cooldown_tick(time, total):
	var time_left = total - time
	RecallCooldownText.text = "Recall: %2.1f" % time_left


func _on_Player_recall_cooldown_end():
	RecallCooldownText.text = "Recall: Ready"

