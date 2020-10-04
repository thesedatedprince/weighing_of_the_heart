extends Area2D

var citizen_textures = [audience.citizen_a_texture, audience.citizen_b_texture]

var speed = 400
var moving = false
var end_y = -5

func _process(delta):
	if moving:
		move_local_y(speed * delta)
		if speed > 0:
			if position.y >= end_y:
				moving = false
		if speed < 0:
			if position.y <= end_y:
				moving = false
				queue_free()

var scores = {}


func _ready():
	var citizen_y_increments = get_node('final_sprite').texture.get_size().y / 3
	var citizen_y_tracker = 10 + get_node('final_sprite').texture.get_size().y / 3
	for tex in citizen_textures:
		var spr = Sprite.new()
		spr.set_texture(tex)
		spr.position.x = tex.get_size().x * 4
		spr.position.y = citizen_y_tracker
		
		add_child(spr)
		
		var label = RichTextLabel.new()
		var font_data = DynamicFontData.new()
		font_data.set_font_path('res://assets/fonts/Apple Chancery.ttf')
		var font = DynamicFont.new()
		font.set_font_data(font_data)
		font.size = 24
		label.add_color_override('default_color', Color('black'))
		label.add_font_override("normal_font", font)
		var text = null
		if citizen_textures.find(tex, 0) == 1:
			text = get_text(scores['total_p'])
		else:
			text = get_text(scores['total_v'])
		label.rect_size = Vector2(500, 100)
		label.set_text(text)
		var lx = spr.position.x + tex.get_size().x
		label.rect_position = Vector2(
			lx,
			citizen_y_tracker - 20
		)
		
		add_child(label)
		
		citizen_y_tracker += citizen_y_increments


func get_text(score):
	if score == 0:
		return 'does not suffer in eternity.'
	if score == 100:
		return 'suffers in eternity.'
	if score == 200:
		return 'experiences extreme suffering in eternity.'