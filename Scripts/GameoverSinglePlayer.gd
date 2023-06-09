extends Sprite

signal get_out

var delay = 2.0
var active = false

var highscores_names = []
var highscores = []

func stop():
	active = false
	$NameChoice.stop()
	$ScoreContainer/Score.score = 0

func reset():
	delay = 2.0
	modulate = Color(1, 1, 1, 0)
	$NameChoice.reset()
	$ScoreContainer/Score.score = 0

func load_scores():
	var save_game = File.new()
	if save_game.file_exists("user://savegame.txt"):
		save_game.open("user://savegame.txt", File.READ)
		highscores_names = []
		highscores = []
		var text = save_game.get_as_text(true)
		for line in text.split("\n"):
			var components = line.split(" ")
			if components.size() == 1:
				continue
			highscores_names.append(components[0])
			highscores.append(int(components[1]))
		save_game.close()

func save_scores():
	var save_game = File.new()
	save_game.open("user://savegame.txt", File.WRITE)
	var inserted = false
	for i in 10:
		if $ScoreContainer/Score.score > highscores[i] && !inserted:
			inserted = true
			save_game.store_line($NameChoice.get_text() + " " + str(int($ScoreContainer/Score.score)).pad_zeros(6))
		else:
			var index = i - (1 if inserted else 0)
			save_game.store_line(highscores_names[index] + " " + str(int(highscores[index])).pad_zeros(6))
	save_game.close()

func start_init_animation(score):
	load_scores()
	
	active = true
	$NameChoice.start()
	$ScoreContainer/Score.score = score
	$AnimationPlayer.play("GameoverSingleplayerIn")

func _process(delta):
	if active:
		if delay > 0:
			delay -= delta
		else:
			if (Input.is_action_just_pressed("0blue1") ||
				Input.is_action_just_pressed("0blue2") ||
				Input.is_action_just_pressed("0red1") ||
				Input.is_action_just_pressed("0red2") ||
				Input.is_action_just_pressed("0yellow1") ||
				Input.is_action_just_pressed("0yellow2") ||
				Input.is_action_just_pressed("0green1") ||
				Input.is_action_just_pressed("0green2")):
				save_scores()
				emit_signal("get_out")
