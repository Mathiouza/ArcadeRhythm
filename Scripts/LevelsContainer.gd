tool
extends Node2D

export(int, 1, 6) var level = 1 setget set_level
export(int, 0, 7) var current_beat = 0 setget set_current_beat

func set_level(new_level):
	if get_child_count() != 0:
		level = new_level
		for levelNode in get_children():
			levelNode.visible = false
		
		get_child(level-1).visible = true
		get_child(level-1).current_beat = current_beat

func set_current_beat(new_beat):
	if get_child_count() != 0:
		current_beat = new_beat
		get_child(level-1).current_beat = current_beat

func get_number_of_beats() -> int:
	if get_child_count() != 0:
		return get_child(level-1).get_number_of_beats()
	return 7
