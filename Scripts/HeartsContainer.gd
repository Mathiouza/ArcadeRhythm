tool
extends Node2D

export(int, 0, 3) var lives = 3 setget set_lives
export(Color) var unlit = Color(0.2, 0.2, 0.2, 1.0) setget set_unlit_color
export(Color) var lit = Color("#f13112") setget set_lit_color

func _ready():
	update_display()

func set_lives(new_value):
	lives = new_value
	update_display()

func set_unlit_color(new_color):
	unlit = new_color
	update_display()

func set_lit_color(new_color):
	lit = new_color
	update_display()

func update_display():
	for i in get_child_count():
		get_child(i).material.set_shader_param("color", lit if i+1 <= lives else unlit)
