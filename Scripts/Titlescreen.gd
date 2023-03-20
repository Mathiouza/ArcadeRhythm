extends Sprite

var audio_position = 0.0
var beats = 0

func _process(delta):
	if Input.is_action_just_pressed("0player"):
		print("1 player")
	
	if Input.is_action_just_pressed("1player"):
		print("2 players")
	
	var new_audio_position = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	
	if new_audio_position < audio_position - 10:
		audio_position -= $AudioStreamPlayer.stream.get_length()
	
	var time_check = 60.0 / 150.0
	if (new_audio_position - audio_position) >= time_check:
		beats = (beats + 1) % $Level1.get_number_of_beats()
		$Level1.set_current_beat(beats + 1)
		audio_position += time_check
