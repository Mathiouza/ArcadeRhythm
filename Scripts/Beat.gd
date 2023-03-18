tool
extends Node2D

export(int, 2, 10) var length = 2 setget set_length
export(Color) var color = Color(1.0, 0.0, 0.0, 1.0) setget set_color

var middles = []

func _ready():
	set_length(length)
	set_color(color)

func set_length(new_length):
	length = new_length
	$Top.position = Vector2(0, -8 - 8 * (new_length - 2))
	$Bottom.position = Vector2(0, 8 + 8 * (new_length - 2))
	
	for i in middles.size():
		middles[i].visible = false
	
	for i in new_length-2:
		if i < middles.size():
			middles[i].position = Vector2(0, -8 * (new_length - 3) + 16 * i)
			middles[i].visible = true
		else:
			var duplicated = $Middle.duplicate()
			duplicated.position = Vector2(0, -8 * (new_length - 3) + 16 * i)
			duplicated.visible = true
			middles.append(duplicated)
			add_child_below_node($Top, duplicated)

func set_color(new_color):
	color = new_color
	$Top.material.set_shader_param("color", color)
	$Bottom.material.set_shader_param("color", color)
	$Middle.material.set_shader_param("color", color)
	for middle in middles:
		middle.material.set_shader_param("color", color)
