extends Node2D

class_name Square

export(Color) var color = Color("#4287f5")

export var x = 0
export var y = 0

export var sprite_size = 16

var is_falling = false

var speed = Vector2(0, 0)
var rotation_speed = 0

func _ready():
	$Sprite.material.set_shader_param("color", color)
	set_pos(x, y)

func _process(delta):
	if is_falling:
		speed += Vector2(0, 300) * delta
		
		position += speed * delta
		rotation += rotation_speed * delta
		
		if position.y > 500:
			queue_free()

func set_x(new_x: int):
	x = new_x
	position = Vector2(x*sprite_size, y*sprite_size)

func set_y(new_y: int):
	y = new_y
	position = Vector2(x*sprite_size, y*sprite_size)

func set_pos(new_x: int, new_y: int):
	set_x(new_x)
	set_y(new_y)

func fall():
	is_falling = true
	
	speed = Vector2(-1 + randf()*2, -1 + randf()*2) * 100
	rotation_speed = randf() * PI
