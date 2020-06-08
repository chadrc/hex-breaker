extends KinematicBody2D

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Ball_body_entered(body):
	if body == self:
		queue_free()
		emit_signal("destroyed", self)
