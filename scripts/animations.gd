extends AnimatedSprite

var moving = false
var speed = -100
var end_x = 0

func _process(delta):
	if moving:
		move_local_x(speed * delta)
		if position.x <= end_x:
			moving = false