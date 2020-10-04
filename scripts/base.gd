extends Node2D

var select_audience = preload('res://scenes/select_audience.tscn')
var start_button = preload('res://scenes/start_button.tscn')
var hint_button = preload('res://scenes/hint_button.tscn')

var hint_screen = preload('res://scenes/hint_screen.tscn')
var item = preload('res://scenes/item.tscn')
var final_scoreboard = preload('res://scenes/final_area.tscn')
var eye_open_texture = preload('res://assets/ui/eye_of_audience_open.png')
var eye_closed_texture = preload('res://assets/ui/eye_of_audience_closed.png')
var select_instances = []
var selected_members = []
var sprite_tracker = []
var start_button_instance = null
var hint_button_instance = null
var clear_item = false

var chair_1 = null
var chair_2 = null
var chair_3 = null
var chair_4 = null

var selecting = true

func _ready():
	chair_1 = get_node('chair_1')
	chair_2 = get_node('chair_2')
	chair_3 = get_node('chair_3')
	chair_4 = get_node('chair_4')
	launch_audience_selection()
	
func _process(delta):
	if selecting:
		for i in select_instances:
			if i.position.y < 0:
				i.position.y += 200 * delta
		check_selected_members()
	
func launch_audience_selection():
	get_node('music_selecting').play()
	var ids = ['sebastian', 'annabelle', 'byron', 'phoebe']
	var position_tracker_x = 95
	for i in ids:
		if audience.audience_members[i]['locked'] == false:
			var select_instance = select_audience.instance()
			var select_instance_size = select_instance.get_node('select_sprite').texture.get_size()
			select_instance.audience_id = i
			select_instance.position.x = position_tracker_x
			select_instance.position.y = 0 - select_instance_size.y
			add_child(select_instance)
			position_tracker_x += select_instance_size.x + 20
			select_instances.append(select_instance)
	start_button_instance = start_button.instance()
	hint_button_instance = hint_button.instance()
	var viewport_size = get_viewport().size
	var start_button_size = start_button_instance.get_node('start_sprite').texture.get_size()
	start_button_instance.position.x = viewport_size.x / 2 - (start_button_size.x / 2)
	start_button_instance.position.y = viewport_size.y / 1.2
	add_child(start_button_instance)
	
	var hint_button_size = hint_button_instance.get_node('hint_button_sprite').texture.get_size()
	hint_button_instance.position.x = start_button_instance.position.x
	hint_button_instance.position.y = start_button_instance.position.y - hint_button_size.y - (hint_button_size.y / 2)
	add_child(hint_button_instance)
			
func check_selected_members():
	if not self.selected_members == audience.selected_members:
		self.selected_members = []
		for member in audience.selected_members:
			self.selected_members.append(member)
		add_audience_sprites()
		
func show_hint_screen():
	var hint_screen_instance = hint_screen.instance()
	var viewport_size = get_viewport().size
	hint_screen_instance.position.x = 0 + viewport_size.x / 12
	add_child(hint_screen_instance)
	get_tree().paused = true

func add_audience_sprites():
	if not sprite_tracker.empty():
		for s in sprite_tracker:
			s.queue_free()
		sprite_tracker = []
	
	var chairs = [chair_1, chair_2, chair_3, chair_4]

	for member in self.selected_members:
		
		var chair = chairs[self.selected_members.find(member,0)]
		var data = audience.audience_members[member]
	
		var audience_sprite_texture = load(data['sprite'])
		var spr = Sprite.new()
		spr.set_texture(audience_sprite_texture)
		spr.position.x = chair.position.x
		spr.position.y = chair.position.y - chair.texture.get_size().y / 1.8
		sprite_tracker.append(spr)
		add_child(spr)

func start_show():
	get_node('music_selecting').stop()
	get_node('music_show').play()
	get_node('poem_board').get_node('poem_text').set_bbcode('[center]Citizen A liked coffee[/center]')
	selecting = false
	for i in select_instances:
		i.queue_free()
	select_instances = []
	start_button_instance.queue_free()
	hint_button_instance.queue_free()
	var curtain_l = get_node('curtain_l')
	var curtain_r = get_node('curtain_r')
	var viewport_size = get_viewport().size

	var active_view = selected_members[0]
	var eye_open = audience.audience_members[active_view]['eye_open']
	var item_instance = null
	
	var eye_spr = Sprite.new()
	
	if eye_open:
		eye_spr.set_texture(eye_open_texture)
	else:
		eye_spr.set_texture(eye_closed_texture)
	
	eye_spr.position = chair_1.position
	eye_spr.z_index = 1
	add_child(eye_spr)
	open_curtains(curtain_l, curtain_r, viewport_size)
	
	var citizen_a_instance = audience.citizen_a_animations.instance()
	var citizen_b_instance = audience.citizen_b_animations.instance()
	
	citizen_a_instance.play('sitting')
	citizen_a_instance.position.x = viewport_size.x / 2
	citizen_a_instance.position.y = viewport_size.y / 2.05 - citizen_a_instance.frames.get_frame("sitting", 0).get_size().y /2 
	citizen_a_instance.position.x = viewport_size.x / 2 - citizen_a_instance.frames.get_frame("sitting", 0).get_size().x /2 
	add_child(citizen_a_instance)
	
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()

	citizen_a_instance.position.y = citizen_a_instance.position.y - 2
	citizen_a_instance.play('drinking')
	yield(citizen_a_instance, 'animation_finished')
	citizen_a_instance.position.y = citizen_a_instance.position.y + 2
	citizen_a_instance.play('sitting')
	
	close_curtains(curtain_l, curtain_r, viewport_size)

	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	citizen_a_instance.queue_free()
	get_node('poem_board').get_node('poem_text').set_bbcode('[center]Citizen B liked tea[/center]')
	
	
	eye_spr.queue_free()
	var clear_eye = null
	if selected_members.size() >= 2:
		active_view = selected_members[1]
		eye_open = audience.audience_members[active_view]['eye_open']
		eye_spr = Sprite.new()
		
		if eye_open:
			eye_spr.set_texture(eye_open_texture)
		else:
			eye_spr.set_texture(eye_closed_texture)
		
		eye_spr.position = chair_2.position
		eye_spr.z_index = 1
		clear_eye = true
		
		if 'sebastian_eye' in audience.inventory and not 'annabelle_eye' in audience.inventory:
			if active_view == 'sebastian' and audience.audience_members[active_view]['eye_open']:
				item_instance = item.instance()
				item_instance.item_id = 'annabelle_eye'
				item_instance.position.x = (viewport_size.x / 2) - (viewport_size.x / 3)
				item_instance.position.y = (viewport_size.y / 2) - (viewport_size.y / 3)
				clear_item = true
				add_child(item_instance)
			
		add_child(eye_spr)

	open_curtains(curtain_l, curtain_r, viewport_size)
	
	citizen_b_instance.flip_h = true
	citizen_b_instance.play('sitting')
	citizen_b_instance.position.x = viewport_size.x / 2
	citizen_b_instance.position.y = viewport_size.y / 2.05 - citizen_b_instance.frames.get_frame("sitting", 0).get_size().y /2 
	citizen_b_instance.position.x = viewport_size.x / 2 - citizen_b_instance.frames.get_frame("sitting", 0).get_size().x /2 
	add_child(citizen_b_instance)
	
	if not 'sebastian_eye' in audience.inventory:
		item_instance = item.instance()
		item_instance.position.x = viewport_size.x / 3
		item_instance.position.y = viewport_size.y - viewport_size.y / 2
		clear_item = true
		add_child(item_instance)
		
	
	timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	citizen_b_instance.position.y = citizen_b_instance.position.y - 2
	citizen_b_instance.play('drinking')
	yield(citizen_b_instance, 'animation_finished')
	citizen_b_instance.position.y = citizen_b_instance.position.y + 2
	citizen_b_instance.play('sitting')
	
	close_curtains(curtain_l, curtain_r, viewport_size)
	
	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	if clear_item:
		item_instance.queue_free()
		clear_item = false
	citizen_b_instance.queue_free()
	get_node('poem_board').get_node('poem_text').set_bbcode('[center]Citizen A missed their train home[/center]')
	
	citizen_a_instance = audience.citizen_a_animations.instance()
	add_child(citizen_a_instance)

	if clear_eye:
		eye_spr.queue_free()
		clear_eye = false
	if selected_members.size() >= 3:
		active_view = selected_members[2]
		eye_open = audience.audience_members[active_view]['eye_open']
		eye_spr = Sprite.new()
		
		if eye_open:
			eye_spr.set_texture(eye_open_texture)
		else:
			eye_spr.set_texture(eye_closed_texture)
		
		eye_spr.position = chair_3.position
		eye_spr.z_index = 1
		clear_eye = true
		
		if 'annabelle_eye' in audience.inventory and not 'byron_eye' in audience.inventory:
			if active_view == 'annabelle' and audience.audience_members[active_view]['eye_open']:
				item_instance = item.instance()
				item_instance.item_id = 'byron_eye'
				item_instance.position.x = (viewport_size.x / 2) + (viewport_size.x / 3)
				item_instance.position.y = (viewport_size.y / 2) + (viewport_size.y / 12)
				clear_item = true
				add_child(item_instance)

		add_child(eye_spr)

	open_curtains(curtain_l, curtain_r, viewport_size)
	
	citizen_a_instance.play('running')
	citizen_a_instance.position.y = viewport_size.y / 2.175 - citizen_a_instance.frames.get_frame("running", 0).get_size().y /2 
	citizen_a_instance.position.x = viewport_size.x / 2 - citizen_a_instance.frames.get_frame("running", 0).get_size().x /2
	citizen_a_instance.moving = true
	
	timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	close_curtains(curtain_l, curtain_r, viewport_size)

	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	if clear_item:
		item_instance.queue_free()
		clear_item = false
	citizen_a_instance.queue_free()
	get_node('poem_board').get_node('poem_text').set_bbcode('[center]Citizen B set them free[/center]')
	citizen_a_instance = audience.citizen_a_animations.instance()
	add_child(citizen_a_instance)

	if clear_eye:
		eye_spr.queue_free()
		clear_eye = false

	if selected_members.size() >= 4:
		active_view = selected_members[3]
		eye_open = audience.audience_members[active_view]['eye_open']
		eye_spr = Sprite.new()
		
		if eye_open:
			eye_spr.set_texture(eye_open_texture)
		else:
			eye_spr.set_texture(eye_closed_texture)
		
		eye_spr.position = chair_4.position
		eye_spr.z_index = 1
		clear_eye = true
		if 'byron_eye' in audience.inventory and not 'phoebe_eye' in audience.inventory:
			if active_view == 'byron' and audience.audience_members[active_view]['eye_open']:
				item_instance = item.instance()
				item_instance.item_id = 'phoebe_eye'
				item_instance.position.x = (viewport_size.x / 2)
				item_instance.position.y = (viewport_size.y / 2) - ((viewport_size.y / 12) * 5)
				clear_item = true
				add_child(item_instance)
		add_child(eye_spr)

	open_curtains(curtain_l, curtain_r, viewport_size)
	
	citizen_a_instance.play('murder')
	citizen_a_instance.position.y = viewport_size.y / 2.15 - citizen_a_instance.frames.get_frame("murder", 0).get_size().y /2 
	citizen_a_instance.position.x = viewport_size.x / 2 - citizen_a_instance.frames.get_frame("murder", 0).get_size().x /2

	timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()

	close_curtains(curtain_l, curtain_r, viewport_size)

	if clear_eye:
		eye_spr.queue_free()

	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	if clear_item:
		item_instance.queue_free()
		clear_item = false
	citizen_a_instance.queue_free()
	
	var scoreboard = load('res://scenes/scoreboard.tscn')
	var scoreboard_instance = scoreboard.instance()
	scoreboard_instance.position.y = 0 - scoreboard_instance.get_node('score_sprite').texture.get_size().y
	scoreboard_instance.position.x = 0 + viewport_size.x / 12
	scoreboard_instance.moving = true
	add_child(scoreboard_instance)
	
	timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	scoreboard_instance.end_y = 0 - scoreboard_instance.get_node('score_sprite').texture.get_size().y
	scoreboard_instance.speed = -400
	scoreboard_instance.moving = true
	
	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	var scores = calculate_scores()
	
	var finalscoreboard = load('res://scenes/final_area.tscn')
	var finalscoreboard_instance = finalscoreboard.instance()
	finalscoreboard_instance.scores = scores
	finalscoreboard_instance.position.y = 0 - finalscoreboard_instance.get_node('final_sprite').texture.get_size().y
	finalscoreboard_instance.position.x = 0 + viewport_size.x / 12
	finalscoreboard_instance.moving = true
	add_child(finalscoreboard_instance)
	
	timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	finalscoreboard_instance.end_y = 0 - finalscoreboard_instance.get_node('final_sprite').texture.get_size().y
	finalscoreboard_instance.speed = -400
	finalscoreboard_instance.moving = true
	
	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	
	var unlocked_character = audience.check_unlocks(scores, audience.selected_members)
	
	if unlocked_character:
		var lockboard = load('res://scenes/lock_board.tscn')
		var lockboard_instance = lockboard.instance()
		lockboard_instance.position.y = 0 - lockboard_instance.get_node('lock_sprite').texture.get_size().y
		lockboard_instance.position.x = 0 + viewport_size.x / 12
		var text = unlocked_character + ' has arrived in the lobby.'
		lockboard_instance.set_child_text(text)
		add_child(lockboard_instance)
		lockboard_instance.moving = true
		
		timer = Timer.new()
		timer.set_wait_time(5)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, 'timeout')
		timer.queue_free()
		
		lockboard_instance.end_y = 0 - lockboard_instance.get_node('lock_sprite').texture.get_size().y
		lockboard_instance.speed = -400
		lockboard_instance.moving = true
		
		timer = Timer.new()
		timer.set_wait_time(3)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, 'timeout')
		timer.queue_free()
		
	if audience.endgame:
		var dialogue = [
			'Byron: Life re-occurs. The victim will repeat this experience over and over',
			'Annabelle: Both were born in sin. The actions of this life are irrelevant - the judgement is pre-decided',
			'Sebastian: Surely there\'s a balance. The victim will be happy in eternity, and the perpetrator will suffer',
			'Phoebe: The moment of death erases one\'s experience of ever having existed. Given time, this all means nothing',
			'Byron: But the victim continues to suffer, over and over in this loop',
			'Phoebe: Yes',
			'Sebastian: For our amusement',
			'Annabelle: I have a suggestion. Surely the way to end the victim\'s suffering in this nightmare is to ensure they never make it to the first scene.',
			'Phoebe: You mean kill the victim before the loop restarts?',
			'Sebastian: And the perpetrator. By my beliefs, it will prevent them suffering an eternity in hell, if they never kill the victim',
			'Byron: If it\'s quick, then their suffering in the return will be less',
			'Annabelle: I could even baptise them first! That means they may avoid God\'s judgement',
			'Phoebe: It makes no difference to me, but I would like to go home at some point.',
			'Sebastian: So we\'re agreed? The only humane and logical thing to do is baptise both of them and painlessly kill them before the loop starts again?',
			'Annabelle: Agreed',
			'Byron: Agreed',
			'Phoebe: Agreed',
			'Sebastian: Ok. Let\'s go'
		]
		get_node('dialogue_canvas').get_node('dialogue_box').page = 0
		get_node('dialogue_canvas').get_node('dialogue_box').dialogue = dialogue
		get_node('dialogue_canvas').get_node('dialogue_box').start()
		audience.end_in_progress = true
	else:
		cleardown()
		launch_audience_selection()
		selecting = true
		
func change_level():
	get_tree().change_scene("res://scenes/ending_1.tscn")
	
func close_curtains(curtain_l, curtain_r, viewport_size):
	curtain_l.speed = 400
	curtain_r.speed = -400
	# This is bullshit, but I'm tired and will settle for the curtain ending up in the middle
	# any way possible
	curtain_l.end_x =  (curtain_l.texture.get_size().x - (viewport_size.x / 2)) * 12
	curtain_r.end_x = viewport_size.x / 2 + (curtain_r.texture.get_size().x / 2)
	curtain_l.moving = true
	curtain_r.moving = true
	
func open_curtains(curtain_l, curtain_r, viewport_size):
	curtain_r.speed = 400
	curtain_l.speed = -400
	curtain_l.end_x = 0 - curtain_l.texture.get_size().x / 2 + (viewport_size.x / 12)
	curtain_r.end_x = viewport_size.x + curtain_l.texture.get_size().x / 2 - (viewport_size.x / 12)
	curtain_l.moving = true
	curtain_r.moving = true
	
func calculate_scores():
	var total_p = 0
	var total_v = 0
	for member in audience.selected_members:
		var data = audience.audience_members[member]
		total_p += data['score_p']
		total_v += data['score_v']
		
	return {
		'total_p': total_p,
		'total_v': total_v,
	}
	
func cleardown():
	select_instances = []
	selected_members = []
	get_node('music_show').stop()
	for s in sprite_tracker:
		s.queue_free()
	sprite_tracker = []
	audience.selected_members = []
	audience.swap_animations()
	