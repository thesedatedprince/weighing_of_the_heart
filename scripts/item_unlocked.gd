extends RichTextLabel

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, 'timeout')
	timer.queue_free()
	self.queue_free()

func set_item_text(item):
	var s = 'You unlocked ' + audience.items[item]
	set_bbcode(s)