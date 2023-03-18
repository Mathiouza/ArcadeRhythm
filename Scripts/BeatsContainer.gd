tool
extends Node2D

export(int, 0, 7) var current_beat = 0 setget set_current_beat
export(Color) var unlit = Color(0.2, 0.2, 0.2, 1.0) setget set_unlit_color
export(Color) var lit = Color(1.0, 0.0, 0.0, 1.0) setget set_lit_color

func _ready():
	update_display()

func set_current_beat(new_beat):
	current_beat = new_beat
	update_display()

func set_unlit_color(new_color):
	unlit = new_color
	update_display()

func set_lit_color(new_color):
	lit = new_color
	update_display()

func update_display():
	var i = 0
	for beat in get_children():
		if i < current_beat:
			beat.color = lit
		else:
			beat.color = unlit
		
		i += 1

func get_number_of_beats() -> int:
	return get_child_count()
