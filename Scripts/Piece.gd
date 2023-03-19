extends Node2D

class_name Piece

var Square = preload("res://Scenes/Square.tscn")

export(PoolVector2Array) var square_positions = []
export(Color) var color = Color("#4287f5")

var squares = []

var rot = 0
var x = 0
var y = 0

func _ready():
	generate_squares()

func generate_squares():
	rotation = rot*PI/2
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

func wrong_placement_animation():
	var step = PI/16
	
	$RotationTween.stop_all()
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2, rot*PI/2 + step, .03)
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2 + step, rot*PI/2, .03)
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2, rot*PI/2 - step, .03)
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2 - step, rot*PI/2, .03)
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2, rot*PI/2 + step, .03)
	$RotationTween.interpolate_property(self, "rotation", rot*PI/2 + step, rot*PI/2, .03)
	$RotationTween.start()

func get_piece_rotation():
	return rot

func get_block_positions(offsetX = 0, offsetY = 0, offsetRot = 0, blocks = []) -> Array:
	var positions = []
	
	for position in (blocks if blocks.size() > 0 else square_positions):
		positions.append(Vector2(
			round(position.x * cos((rot + offsetRot)*PI/2) - position.y * sin((rot + offsetRot)*PI/2)) + x + offsetX,
			round(position.x * sin((rot + offsetRot)*PI/2) + position.y * cos((rot + offsetRot)*PI/2)) + y + offsetY
		))
	
	return positions

func update_display():
	position = Vector2(x*16+8, y*16+8)
	rotation = rot*PI/2
