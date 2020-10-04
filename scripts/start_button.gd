extends Area2D

var start_texture = preload('res://assets/ui/start button.png')
var select_texture = preload('res://assets/ui/select_characters.png')

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			if audience.selected_members.size() > 0:
				get_parent().get_node('select_sound').play()
				get_parent().start_show()

func update_sprite():
	var spr = get_node("start_sprite")
	if audience.selected_members.size() > 0:
		spr.set_texture(start_texture)
	else:
		spr.set_texture(select_texture)