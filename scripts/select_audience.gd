extends Area2D

var audience_id = 'sebastian'

func _ready():
	var data = audience.audience_members[audience_id]
	
	var audience_sprite_texture = load(data['sprite'])
	var spr = Sprite.new()
	spr.set_texture(audience_sprite_texture)
	var select_sprite = get_node('select_sprite')
	spr.position.x = select_sprite.position.x + select_sprite.texture.get_size().x / 2
	spr.position.y = select_sprite.position.y + select_sprite.texture.get_size().y / 4
	add_child(spr)
	
	var select_name = get_node('select_name')
	select_name.set_text(data['name'])
	
	var select_alignment = get_node('select_alignment')
	select_alignment.set_text(data['alignment'])

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			get_parent().get_node('select_sound').play()
			if not audience_id in audience.selected_members:
				audience.selected_members.append(audience_id)
				get_parent().start_button_instance.update_sprite()
			else:
				audience.selected_members.erase(audience_id)
				get_parent().start_button_instance.update_sprite()
