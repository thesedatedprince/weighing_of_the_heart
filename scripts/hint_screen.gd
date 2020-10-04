extends Area2D


func _process(delta):
	if Input.is_action_just_released("ui_accept") and get_tree().paused == true:
		get_tree().paused = false
		queue_free()