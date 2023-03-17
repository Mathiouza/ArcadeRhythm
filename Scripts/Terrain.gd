extends Node2D

const PieceScript = preload("res://Scripts/Piece.gd")
var Piece = preload("res://Scenes/Piece.tscn")

var current_piece : Piece

func _ready():
	create_piece()

func create_piece():
	current_piece = Piece.instance()
	add_child(current_piece)

func _process(delta):
	if Input.is_action_just_pressed("0up"):
		current_piece.move(0, -1)
	
	if Input.is_action_just_pressed("0right"):
		current_piece.move(1, 0)
	
	if Input.is_action_just_pressed("0down"):
		current_piece.move(0, 1)
	
	if Input.is_action_just_pressed("0left"):
		current_piece.move(-1, 0)
	
	if Input.is_action_just_pressed("0red1"):
		current_piece.turn(true)
	
	if Input.is_action_just_pressed("0red2"):
		current_piece.turn(false)
	
	if Input.is_action_just_pressed("0yellow1"): # ceci est un test pour voir si la fonction get_block_positions fonctionne
		var positions = current_piece.get_block_positions()
		current_piece.queue_free()
		current_piece = Piece.instance()
		current_piece.shape = PieceScript.SHAPE.L3
		current_piece.square_positions = positions
		add_child(current_piece)
