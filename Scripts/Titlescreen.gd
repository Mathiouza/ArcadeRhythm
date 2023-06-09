extends Sprite

signal start_game(two_players)

var audio_position = 0.0
var beats = 0

var focused = false

var highscores = []

func _ready():
	load_scores()

func _process(_delta):
	if focused:
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

func load_scores():
	var save_game = File.new()
	if !save_game.file_exists("user://savegame.txt"):
		highscores = [
			"POL 100000",
			"YGA 080000",
			"MES 050000",
			"WHA 020000",
			"TAG 010000",
			"AME 005000",
			"WOW 004000",
			"GEN 002500",
			"IAL 001500",
			"AAA 000500"
		]
		save_game.open("user://savegame.txt", File.WRITE)
		for line in highscores:
			save_game.store_line(line)
		save_game.close()
	else:
		save_game.open("user://savegame.txt", File.READ)
		highscores = []
		var text = save_game.get_as_text(true)
		highscores = text.split("\n")
		save_game.close()
	
	update_highscore_label()

func update_highscore_label():
	$HighscoreContainer/HighscoreLabel.text = "Highscores"
	for highscore in highscores:
		$HighscoreContainer/HighscoreLabel.text += "\n" + highscore

func start(two_players: bool):
	focused = false
	emit_signal("start_game", two_players)

func stop_audioplayer():
	$AudioStreamPlayer.stop()

func resume():
	audio_position = 0
	beats = 0
	$Level1.set_current_beat(beats + 1)
	$AudioStreamPlayer.play()

func focus():
	load_scores()
	focused = true
