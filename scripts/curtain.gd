extends Sprite

var speed = 400
var moving = false
var end_x = 0

func _process(delta):
	if moving:
		move_local_x(speed * delta)
		if speed > 0:
			if position.x >= end_x:
				moving = false
		elif speed < 0:
			if position.x <= end_x:
				moving = false