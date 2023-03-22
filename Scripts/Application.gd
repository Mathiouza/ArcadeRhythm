extends Node2D

func _on_Titlescreen_start_game(two_players):
	$Titlescreen.hide()
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
