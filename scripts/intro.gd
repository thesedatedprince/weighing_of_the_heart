extends Node2D

var narrator_sprites = null
var playing = 'standing'

func _ready():
	narrator_sprites = get_node('narrator_sprites')

func update_sprite():
	if playing == 'standing':
		playing = 'arm_out'
		narrator_sprites.play(playing)
		return
	elif playing == 'arm_out':
		playing = 'both_arms'
		narrator_sprites.play(playing)
		return
	elif playing == 'both_arms':
		playing = 'standing'
		narrator_sprites.play(playing)
		return
		
func change_level():
	get_tree().change_scene("res://scenes/base.tscn")