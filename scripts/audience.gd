extends Node

var base_path = 'res://assets/audience/'
var endgame = false
var end_in_progress = false

var kirsty_animations = preload('res://scenes/kirsty_animations.tscn')
var ben_animations = preload('res://scenes/ben_animations.tscn')

var kirsty_head = preload('res://assets/citizen a/head.png')
var ben_head = preload('res://assets/citizen b/head.png')

var citizen_a_texture = kirsty_head
var citizen_b_texture = ben_head

var citizen_a_animations = kirsty_animations
var citizen_b_animations = ben_animations

var selected_members = []
var inventory = []

var audience_members = {
	"sebastian": {
		"name": "Sebastian Fitch",
		"alignment": "Divine Judgement - Compassionate",
		"sprite": base_path + "sebastian.png",
		"score_p": 100,
		"score_v": 0,
		"locked": false,
		"eye_open": false,
	},
	"annabelle": {
		"name": "Annabelle Weiss",
		"alignment": "Divine Judgement - Strict",
		"sprite": base_path + "annabelle.png",
		"score_p": 100,
		"score_v": 100,
		"locked": true,
		"eye_open": false,
	},
	"byron": {
		"name": "Byron Lindermann",
		"alignment": "Reincarnationist",
		"sprite": base_path + "byron.png",
		"score_p": 0,
		"score_v": 100,
		"locked": true,
		"eye_open": false,
	},
	"phoebe": {
		"name": "Phoebe Donovan",
		"alignment": "Existential Nihilist",
		"sprite": base_path + "phoebe.png",
		"score_p": 0,
		"score_v": 0,
		"locked": true,
		"eye_open": false,
	},
}

var items = {
	'sebastian_eye': 'Sebastian\'s Eye',
	'annabelle_eye': 'Annabelle\'s Eye',
	'byron_eye': 'Byron\'s Eye',
	'phoebe_eye': 'Phoebe\'s Eye'
}

func is_true_ending():
	return 'sebastian_eye' in inventory and 'annabelle_eye' in inventory and 'byron_eye' in inventory and 'phoebe_eye' in inventory

func check_unlocks(scores, characters_used):
	var character_unlocked = null
	if scores['total_p'] == 100 and scores['total_v'] == 0:
		character_unlocked = unlock_character('annabelle')
	if scores['total_p'] == 100 and scores['total_v'] == 100:
		character_unlocked = unlock_character('byron')
	if scores['total_p'] == 100 and scores['total_v'] == 200:
		character_unlocked = unlock_character('phoebe')
	if scores['total_p'] == 200 and scores['total_v'] == 200 and characters_used.size() == 4:
		endgame = true
	return character_unlocked

func unlock_character(character_id):
	if audience_members[character_id]['locked'] == false:
		return false
	audience_members[character_id]['locked'] = false
	return character_id
	
func check_item(item_id):
	if item_id == 'sebastian_eye':
		audience_members['sebastian']['eye_open'] = true
	if item_id == 'annabelle_eye':
		audience_members['annabelle']['eye_open'] = true
	if item_id == 'byron_eye':
		audience_members['byron']['eye_open'] = true
	if item_id == 'phoebe_eye':
		audience_members['phoebe']['eye_open'] = true
		
func swap_animations():
	if citizen_a_animations == kirsty_animations:
		citizen_a_animations = ben_animations
		citizen_b_animations = kirsty_animations
		citizen_a_texture = ben_head
		citizen_b_texture = kirsty_head
	else:
		citizen_a_animations = kirsty_animations
		citizen_b_animations = ben_animations
		citizen_a_texture = kirsty_head
		citizen_b_texture = ben_head	
		