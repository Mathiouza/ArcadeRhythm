extends Node2D

class_name Square

export(Color) var color = Color("#4287f5")

export var x = 0
export var y = 0

export var sprite_size = 16

func _ready():
	$Sprite.material.set_shader_param("color", color)
	set_pos(x, y)

func set_x(x: int):
	self.x = x
	position = Vector2(self.x*sprite_size, self.y*sprite_size)

func set_y(y: int):
	self.y = y
	position = Vector2(self.x*sprite_size, self.y*sprite_size)

func set_pos(x: int, y: int):
	set_x(x)
	set_y(y)
