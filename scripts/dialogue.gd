extends RichTextLabel

var dialogue = [
	"Good evening",
	"Tonight we pose a moral dilemma",
	"In the aftermath of a violent and tragic incident, what consequences are faced?",
	"Does some celestial judgement balance the suffering of perpetrator and victim, or is all meaningless?",
	"Tonight, two people will be forced to enact their demise, over and over.",
	"An unpleasant murder-suicide you will see soon enough.",
	"Your job is to manage the audience. We have people of all beliefs heading to our lobby.",
	"We want to quantify those beliefs.",
	"When the nihilist meets the religious meets the humanist, we want to see the total eternal suffering they believe both the perpetrator and the victim will face",
	"The aim of that measure is to answer the question: In eternity, does the suffering endured within life truly matter?",
	"In a moment, you will be asked to arrange your audience",
	"Also, click on the sparkly things you see in scene - it will help your audience see more",
	"I bid you a good evening"
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
				get_parent().update_sprite()
				set_bbcode(dialogue[page])
				set_visible_characters(0)
			else:
				get_parent().change_level()
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