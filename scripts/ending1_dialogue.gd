extends RichTextLabel

var dialogue = [
	"Citizen A: Wh..what are you people doing?",
	"Annabelle: In the name of the father, the son...",
	"Citizen B: Please, this isn't what you think!",
	"Byron: This way is best. Your suffering will be reduced.",
	"Citzen A: For the love of God, I have a daughter!",
	"Citizen A: I HAVE A DAUGHTER!!!",
	"Annabelle: Amen",
]

var page = 0
var _timer = Timer.new()

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	_create_timer()
	set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed('ui_accept'):
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				set_bbcode(dialogue[page])
				set_visible_characters(0)
			else:
				if audience.is_true_ending():
					get_tree().change_scene('res://scenes/ending_2.tscn')
				else:
					get_tree().change_scene('res://scenes/base.tscn')
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