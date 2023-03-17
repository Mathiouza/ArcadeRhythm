extends Node2D

class_name Piece

var Square = preload("res://Scenes/Square.tscn")

enum SHAPE {L3, L4, Lr3, Lr4, PLUS5, PLUS9, LONG3, LONG4, LONG6}

export(SHAPE) var shape = SHAPE.L4
export(Color) var color = Color("#4287f5")

var squares = []
var square_positions = []

var time = 0

var rot = 0
var x = 0
var y = 0

func _ready():
	match shape:
		SHAPE.PLUS9:
			square_positions = [
				Vector2(0, 0),
				Vector2(1, 0),
				Vector2(2, 0),
				Vector2(-1, 0),
				Vector2(-2, 0),
				Vector2(0, 1),
				Vector2(0, 2),
				Vector2(0, -1),
				Vector2(0, -2)
			]
		SHAPE.PLUS5:
			square_positions = [
				Vector2(0, 0),
				Vector2(1, 0),
				Vector2(0, 1),
				Vector2(-1, 0),
				Vector2(0, -1)
			]
		SHAPE.L4:
			square_positions = [
				Vector2(0, 0),
				Vector2(0, -1),
				Vector2(0, -2),
				Vector2(1, 0)
			]
	
	generate_squares(square_positions)

func _process(delta):
	time += delta
	
	if time >= 0.4:
		time -= 0.4
		pulsate()

func generate_squares(square_positions):
	for v in square_positions:
		var instance = Square.instance()
		instance.color = color
		instance.x = v.x
		instance.y = v.y
		position = Vector2(x*16+8, y*16+8)
		squares.append(instance)
		add_child(instance)

func turn(positive: bool):
	$RotationTween.stop_all()
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2, (rot + (1 if positive else -1))*PI/2, .15, Tween.TRANS_QUART, Tween.EASE_OUT)
	$RotationTween.start()
	
	rot = (rot + (1 if positive else -1) + 4) % 4

func move(offsetX: int, offsetY: int):
	$TranslationTween.stop_all()
	$TranslationTween.interpolate_property(self, "position", Vector2(x*16+8, y*16+8), Vector2((x+offsetX)*16+8, (y+offsetY)*16+8), .15, Tween.TRANS_QUART, Tween.EASE_OUT)
	$TranslationTween.start()
	
	x += offsetX
	y += offsetY

func pulsate():
	$PulsateTween.stop_all()
	$PulsateTween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(1.2, 1.2), .1, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$PulsateTween.interpolate_property(self, "scale", Vector2(1.2, 1.2), Vector2(1, 1), .1, Tween.TRANS_CIRC, Tween.EASE_IN)
	$PulsateTween.start()

func get_piece_rotation():
	return rot

func get_block_positions() -> Array:
	var positions = []
	
	for position in square_positions:
		positions.append(Vector2(
			round(position.x * cos(rot*PI/2) - position.y * sin(rot*PI/2)) + x,
			round(position.x * sin(rot*PI/2) + position.y * cos(rot*PI/2)) + y
		))
	
	return positions
