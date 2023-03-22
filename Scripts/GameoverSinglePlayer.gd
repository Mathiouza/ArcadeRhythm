extends Sprite

signal get_out

var active = false

func stop():
	active = false
	$NameChoice.stop()
	$ScoreContainer/Score.score = 0

func reset():
	modulate = Color(1, 1, 1, 0)
	$NameChoice.reset()
	$ScoreContainer/Score.score = 0

func start_init_animation(score):
	active = true
	$NameChoice.start()
	$ScoreContainer/Score.score = score
	$AnimationPlayer.play("GameoverSingleplayerIn")

func _process(delta):
	if active:
		if Input.is_action_just_pressed("0red1") || Input.is_action_just_pressed("0red2"):
			emit_signal("get_out")
