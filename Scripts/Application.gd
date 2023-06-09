extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if Input.is_action_just_pressed("0credit") or Input.is_action_just_pressed("1credit"):
		get_tree().quit()

func _on_Titlescreen_start_game(two_players):
	$Titlescreen.hide()
	$Tutorial.reset(two_players)
	$Tutorial.show()

func _on_Tutorial_start(two_players):
	$Titlescreen.stop_audioplayer()
	$Tutorial.hide()
	$Game.two_players = two_players
	$Game.reset()
	$Game.show()
	$Game.preparation()

func _on_Game_gameover_single(score):
	$Game.stop()
	$Game.hide()
	$Titlescreen.resume()
	$GameoverSinglePlayer.reset()
	$GameoverSinglePlayer.show()
	$GameoverSinglePlayer.start_init_animation(score)

func _on_GameoverSinglePlayer_get_out():
	$GameoverSinglePlayer.stop()
	$GameoverSinglePlayer.hide()
	$Titlescreen.focus()
	$Titlescreen.show()

func _on_Game_gameover_two(num_terrain):
	$Game.stop()
	$Game.hide()
	$Titlescreen.resume()
	$GameoverTwoPlayer.reset()
	$GameoverTwoPlayer.show()
	$GameoverTwoPlayer.start_init_animation(num_terrain)
	$Timer.start()

func _on_Timer_timeout():
	$GameoverTwoPlayer.hide()
	$Titlescreen.focus()
	$Titlescreen.show()
