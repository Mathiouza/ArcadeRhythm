tool
extends Node2D

var background_texture = preload("res://Assets/Sprites/Background.png")
var background_two_players_texture = preload("res://Assets/Sprites/BackgroundTwoPlayers.png")

var speed = 0
onready var audio_players = [
	$a100,
	$a125,
	$a150,
	$a175,
	$a200
]
var bpms = [
	100, 125, 150, 175, 200
]
var audio_position = 0.0

var actual_level = 1

export var two_players = false setget set_two_players

func _ready():
	set_two_players(two_players)

func _process(delta):
	if !Engine.editor_hint:
#		var prec_speed = speed
		
#		if Input.is_action_just_pressed("0red1"):
#			speed = min(speed + 1, 4)
#
#		if Input.is_action_just_pressed("0red2"):
#			speed = max(speed - 1, 0)
		
#		if prec_speed != speed:
#			change_tempo(prec_speed, speed)
			
		var new_audio_position = audio_players[speed].get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		
		var time_check = 1.0 / (bpms[speed] / 60.0)
		if (new_audio_position - audio_position) >= time_check:
			$Terrain1.pulsate()
			$Terrain2.pulsate()
			audio_position = new_audio_position

func change_tempo(prec_speed, new_speed):
	var pos = audio_players[prec_speed].get_playback_position()

	for player in audio_players:
		player.volume_db = -200
		player.stop()
	
	audio_players[speed].play(pos * bpms[prec_speed] / bpms[speed])
	audio_players[speed].volume_db = 0
	
	audio_position *= bpms[prec_speed] / bpms[speed]

func set_two_players(new_value):
	if $Terrain2 != null:
		two_players = new_value
		
		$Terrain2.visible = two_players
		$Terrain2.active = two_players
		
		$Terrain1.position = Vector2(71 if two_players else 170, $Terrain1.position.y)
		
		$Background.texture = background_two_players_texture if two_players else background_texture



func _on_Terrain1_music_level(music_level, forced_level):
	if music_level > actual_level:
		$Terrain2.set_forced_level(forced_level)
		music_level_up(music_level)


func _on_Terrain2_music_level(music_level, forced_level):
	if music_level > actual_level:
		$Terrain1.set_forced_level(forced_level)
		music_level_up(music_level)


func music_level_up(music_level):
	actual_level = music_level
	var prec_speed = speed
	speed = music_level - 1
	change_tempo(prec_speed, speed)
