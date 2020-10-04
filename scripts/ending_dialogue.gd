extends RichTextLabel

var dialogue = ['']

var page = 0
var _timer = Timer.new()

func start():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	_create_timer()
	set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed('ui_accept') and audience.end_in_progress:
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				set_bbcode(dialogue[page])
				set_visible_characters(0)
			else:
				get_parent().get_parent().change_level()
		else:
			set_visible_characters(get_total_character_count())

func _create_timer():
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()

func _on_timer_timeout():
	set_visible_characters(get_visible_characters() + 1)