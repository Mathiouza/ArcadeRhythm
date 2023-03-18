extends Node2D

var speed = 0
var audio_players = []
var bpms = [
	100, 125, 150, 175, 200
]

export var two_players = false

func _ready():
	audio_players = [
		$a100,
		$a125,
		$a150,
		$a175,
		$a200
	]
	
	if two_players:
		$Terrain2.visible = true
		$Terrain2.active = true
	else:
		$Terrain2.visible = false
		$Terrain2.active = false

func _process(delta):
	var prec_speed = speed
	
	if Input.is_action_just_pressed("0red1"):
		speed = min(speed + 1, 4)
	
	if Input.is_action_just_pressed("0red2"):
		speed = max(speed - 1, 0)
	
	if prec_speed != speed:
		change_tempo(prec_speed, speed)

func change_tempo(prec_speed, new_speed):
	var audio_position = audio_players[prec_speed].get_playback_position()
	audio_players[prec_speed].stop()
	
	audio_players[speed].play(audio_position * bpms[prec_speed] / bpms[speed])
