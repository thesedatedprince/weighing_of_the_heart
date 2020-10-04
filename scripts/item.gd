extends Area2D

var item_id = 'sebastian_eye'
var item_unlocked = preload('res://scenes/item_unlocked.tscn')

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			audience.inventory.append(item_id)
			audience.check_item(item_id)
			get_parent().get_node('select_sound').play()
			var ins = item_unlocked.instance()
			ins.set_item_text(item_id)
			get_parent().get_node('dialogue_canvas').add_child(ins)
			get_parent().clear_item = false
			queue_free()