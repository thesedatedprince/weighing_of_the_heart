extends Area2D

var speed = 400
var moving = false
var end_y = -5


func _process(delta):
	if moving:
		move_local_y(speed * delta)
		if speed > 0:
			if self.position.y >= end_y:
				moving = false
		if speed < 0:
			if self.position.y <= end_y:
				moving = false
				queue_free()

			
func set_child_text(text):
	get_node('lock_text').set_text(text)