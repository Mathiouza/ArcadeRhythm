extends Sprite

signal get_out

var time_passed = 0

func _ready():
	pass 


func _process(delta):
	pass

func reset():
	modulate = Color(1, 1, 1, 0)
	
func start_init_animation(num_terrain):
	if num_terrain == 2:
		$GameOverLabel.text = "PLAYER 1\nWINS!"
	else:
		$GameOverLabel.text = "PLAYER 2\nWINS!"
	
	$AnimationPlayer.play("GameoverSingleplayerIn")
