extends Label

export (NodePath) var ball_path
export (NodePath) var player_path

var ball
var player

func _ready():
	ball = get_node(ball_path)
	player = get_node(player_path)
	
	Engine.time_scale = .1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dif = player.position - ball.position
	
	var d
	var t
	if dif.x == 0:
		d = 0
		t = 0
	else:
		d = dif.normalized().dot(Vector2.RIGHT)
		t = atan(dif.y / dif.x)
	
	var deg = rad2deg(t)
	# start off in 2nd quadrant
	# check if were in other three
	if ball.position.x > player.position.x and ball.position.y <= player.position.y:
		# 1st quadrant
		deg = 180.0 - abs(deg)
	elif ball.position.x <= player.position.x and ball.position.y > player.position.y:
		# 3rd quadrant
		deg = 360.0 - abs(deg)
	elif ball.position.x > player.position.x and ball.position.y > player.position.y:
		# 4th quadrant
		deg = 180 + deg
	
	# ball is below player
#	if ball.position.y > player.position.y:
#		deg = 360.0 - deg
		
#	deg = int(deg - player.rotation_degrees) % 360
	
	text = "Angle: %3.1f | Tan: %3.1f" % [deg, t]
	

func _draw():
	draw_line(player.physics_position, ball.physics_position, Color.red)
	draw_line(player.position, ball.position, Color.green)
	draw_line(player.position, player.position + Vector2.RIGHT * 1000, Color.green)
