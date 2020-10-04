extends Area2D

var tick_texture = preload('res://assets/ui/tick.png')
var cross_texture = preload('res://assets/ui/cross.png')

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

func _ready():
	var citizen_y_increments = get_node('score_sprite').texture.get_size().y / 3
	var citizen_y_tracker = 10 + get_node('score_sprite').texture.get_size().y / 3
	for tex in citizen_textures:
		var spr = Sprite.new()
		spr.set_texture(tex)
		spr.position.x = tex.get_size().x * 1.5
		spr.position.y = citizen_y_tracker
		citizen_y_tracker += citizen_y_increments
		add_child(spr)

	var audience_x_increments = get_node('score_sprite').texture.get_size().y / 6
	var audience_x_tracker = audience_x_increments * 3
	var tallest_audience = 66
	for member in audience.selected_members:
		var data = audience.audience_members[member]
		
		var audience_sprite_texture = load(data['sprite'])
		var spr = Sprite.new()
		spr.set_texture(audience_sprite_texture)
		spr.set_scale(Vector2(0.7, 0.7))

		spr.position.x = audience_x_tracker
		spr.position.y = 60 + ((tallest_audience - audience_sprite_texture.get_size().y) * 0.35)
		
		
		add_child(spr)

		var score_y_increments = get_node('score_sprite').texture.get_size().y / 3
		var score_y_tracker = 10 + get_node('score_sprite').texture.get_size().y / 3		
		spr = Sprite.new()
		if data['score_v'] == 100:
			spr.set_texture(tick_texture)
		else:
			spr.set_texture(cross_texture)
		
		spr.position.x = audience_x_tracker
		spr.position.y = score_y_tracker
		add_child(spr)

		spr = Sprite.new()
		if data['score_p'] == 100:
			spr.set_texture(tick_texture)
		else:
			spr.set_texture(cross_texture)
			
		spr.position.x = audience_x_tracker
		spr.position.y = score_y_tracker + score_y_increments
		
		add_child(spr)
		audience_x_tracker += audience_x_increments * 3
	
