extends Node2D



func _on_Titlescreen_start_game(two_players):
	$Titlescreen.hide()
	$Game.two_players = two_players
	$Game.reset()
	$Game.show()
	$Game.preparation()
