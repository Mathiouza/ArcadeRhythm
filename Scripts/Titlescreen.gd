extends Sprite

signal start_game(two_players)

var audio_position = 0.0
var beats = 0

var focused = true

func _process(delta):
	if $AudioStreamPlayer.playing:
		if Input.is_action_just_pressed("0player"):
			start(false)
		
		if Input.is_action_just_pressed("1player"):
			start(true)
		
		var new_audio_position = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		
		if new_audio_position < audio_position - 10:
			audio_position -= $AudioStreamPlayer.stream.get_length()
		
		var time_check = 60.0 / 150.0
		if (new_audio_position - audio_position) >= time_check:
			beats = (beats + 1) % $Level1.get_number_of_beats()
			$Level1.set_current_beat(beats + 1)
			audio_position += time_check

func start(two_players: bool):
	$AudioStreamPlayer.stop()
	emit_signal("start_game", two_players)

func resume():
	audio_position = 0
	beats = 0
	$Level1.set_current_beat(beats + 1)
	$AudioStreamPlayer.play()
