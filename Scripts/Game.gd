tool
extends Node2D

signal gameover_single(score)
signal gameover_two(num_terrain)

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

export var two_players = false setget set_two_players

var playing = false

func _ready():
	set_two_players(two_players)

func _process(_delta):
	if !Engine.editor_hint && playing:
		var new_audio_position = audio_players[speed].get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		
		if new_audio_position < audio_position - 10:
			audio_position -= audio_players[speed].stream.get_length()
		
		var time_check = 60.0 / bpms[speed]
		if (new_audio_position - audio_position) >= time_check:
			audio_position = new_audio_position
			$Terrain1.pulsate()
			$Terrain2.pulsate()
			audio_position = audio_players[speed].get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func stop():
	for player in audio_players:
		player.volume_db = -200
		player.stop()
	$Terrain1.active = false
	$Terrain2.active = false
	playing = false

func preparation():
	$Terrain1.active = false
	$Terrain2.active = false
	$Tween.interpolate_callback($Message, 0, "start_animation", "3")
	$Tween.interpolate_callback($Message, 1, "start_animation", "2")
	$Tween.interpolate_callback($Message, 2, "start_animation", "1")
	$Tween.interpolate_callback(self, 3, "play")
	$Tween.start()

func reset():
	audio_position = 0
	speed = 0
	$MusicSpeedContainer/MusicSpeed.current_beat = 1
	$Terrain1.reset()
	$Terrain2.reset()

func play():
	audio_players[speed].play()
	audio_players[speed].volume_db = 0
	$Terrain1.play()
	if two_players:
		$Terrain2.play()
	playing = true

func change_tempo(prec_speed, new_speed):
	if !playing:
		return
	
	var pos = audio_players[prec_speed].get_playback_position()

	for player in audio_players:
		player.volume_db = -200
		player.stop()
	
	$MusicSpeedContainer/MusicSpeed.current_beat = speed + 1
	
	audio_players[speed].play(pos * bpms[prec_speed] / bpms[new_speed])
	audio_players[speed].volume_db = 0
	
	audio_position *= bpms[prec_speed] / bpms[new_speed]

func set_two_players(new_value):
	if $Terrain2 != null:
		two_players = new_value
		
		$Terrain2.visible = two_players
		$Terrain2.active = two_players
		
		$Terrain1.position = Vector2(71 if two_players else 170, $Terrain1.position.y)
		
		$Background.texture = background_two_players_texture if two_players else background_texture

func _on_Terrain1_music_level(music_level, forced_level):
	if music_level > speed+1:
		$Terrain2.set_forced_level(forced_level)
		music_level_up(music_level)

func _on_Terrain2_music_level(music_level, forced_level):
	if music_level > speed+1:
		$Terrain1.set_forced_level(forced_level)
		music_level_up(music_level)

func music_level_up(music_level):
	var prec_speed = speed
	speed = music_level - 1
	change_tempo(prec_speed, speed)

func _on_gameover(num_terrain):
	if !two_players:
		emit_signal("gameover_single", $Terrain1.score)
	else:
		emit_signal("gameover_two", num_terrain)
