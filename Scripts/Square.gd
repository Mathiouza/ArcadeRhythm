extends Node2D

export(Color) var color = Color("#4287f5")

export var x = 0
export var y = 0

export var sprite_size = 16

func _ready():
	$Sprite.modulate = color
	set_pos(x, y)

func set_x(x: int):
	self.x = x
	position = Vector2(self.x*16, self.y*16)

func set_y(y: int):
	self.y = y
	position = Vector2(self.x*16, self.y*16)

func set_pos(x: int, y: int):
	set_x(x)
	set_y(y)
