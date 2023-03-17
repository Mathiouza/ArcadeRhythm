extends Node2D

var Piece = preload("res://Scenes/Piece.tscn")
var Square = preload("res://Scenes/Square.tscn")

enum SHAPE {L3 = 0, L4 = 1, PLUS5 = 2, I2 = 3, I3 = 4, RL4 = 5, T = 6}

const shapes = [
	[
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 1),
	],
	[
		Vector2(0, 0),
		Vector2(0, -1),
		Vector2(0, -2),
		Vector2(1, 0)
	],
	[
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1)
	],
	[
		Vector2(0, 0),
		Vector2(1, 0)
	],
	[
		Vector2(-1, 0),
		Vector2(0, 0),
		Vector2(1, 0)
	],
	[
		Vector2(0, 0),
		Vector2(0, -1),
		Vector2(0, -2),
		Vector2(-1, 0)
	],
	[
		Vector2(0, 0),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(-1, 0)
	]
]

export var controller = 0
export var width = 12
export var height = 12

var current_piece : Piece
var next_piece : Piece
var squares = []

var square_positions: PoolVector2Array = []

func _ready():
	randomize()
	
	next_piece = Piece.instance()
	next_piece.square_positions = shapes[randi() % SHAPE.size()]
	$NextPieceContainer.add_child(next_piece)
	
	create_piece()

func create_piece():
	current_piece = Piece.instance()
	current_piece.x = 3
	current_piece.y = 3
	current_piece.square_positions = shapes[randi() % SHAPE.size()]
	add_child(current_piece)

func _process(delta):
	if Input.is_action_just_pressed(str(controller)+"up") && check_before_movement(current_piece.x, current_piece.y-1, current_piece.rot, current_piece.square_positions):
		current_piece.move(0, -1)
	
	if Input.is_action_just_pressed(str(controller)+"right") && check_before_movement(current_piece.x+1, current_piece.y, current_piece.rot, current_piece.square_positions):
		current_piece.move(1, 0)
	
	if Input.is_action_just_pressed(str(controller)+"down") && check_before_movement(current_piece.x, current_piece.y+1, current_piece.rot, current_piece.square_positions):
		current_piece.move(0, 1)
	
	if Input.is_action_just_pressed(str(controller)+"left") && check_before_movement(current_piece.x-1, current_piece.y, current_piece.rot, current_piece.square_positions):
		current_piece.move(-1, 0)
	
	if Input.is_action_just_pressed(str(controller)+"red1") && check_before_movement(current_piece.x, current_piece.y, current_piece.rot+1, current_piece.square_positions):
		current_piece.turn(true)
	
	if Input.is_action_just_pressed(str(controller)+"red2") && check_before_movement(current_piece.x, current_piece.y, current_piece.rot-1, current_piece.square_positions):
		current_piece.turn(false)
	
	if Input.is_action_just_pressed(str(controller)+"yellow1"):
		var positions = current_piece.get_block_positions()
		
		for block_pos in positions:
			square_positions.append(block_pos)
			
			var new_square = Square.instance()
			new_square.color = current_piece.color
			new_square.x = block_pos.x
			new_square.y = block_pos.y
			squares.append(new_square)
			$BlocksContainer.add_child(new_square)
		
		check_for_clears()
		
		current_piece.queue_free()
		
		var blocks = next_piece.square_positions
		var next_color = next_piece.color
		
		next_piece.queue_free()
		next_piece = Piece.instance()
		next_piece.square_positions = shapes[randi() % SHAPE.size()]
		next_piece.color = Color(randf(), randf(), randf())
		$NextPieceContainer.add_child(next_piece)
		
		var possible_placements = []
		
		for i in range(width):
			for j in range(height):
				for k in range(4):
					if check_before_movement(i, j, k, blocks):
						possible_placements.append([i, j, k])
		
		if possible_placements.size() == 0:
			print("gameover")
		else:
			var placement = possible_placements[randi() % possible_placements.size()]
			
			current_piece = Piece.instance()
			
			current_piece.x = placement[0]
			current_piece.y = placement[1]
			current_piece.rot = placement[2]
			current_piece.square_positions = blocks
			current_piece.color = next_color
			
			add_child(current_piece)

func check_before_movement(offsetX, offsetY, offsetRot, blocks) -> bool:
	var positions = get_block_positions_on_terrain(offsetX, offsetY, offsetRot, blocks)
	
	for block_pos in positions:
		if block_pos in square_positions || block_pos.x < 0 || block_pos.y < 0 || block_pos.x >= width || block_pos.y >= height:
			return false
	
	return true

func get_block_positions_on_terrain(offsetX, offsetY, offsetRot, blocks) -> Array:
	var positions = []
	
	for block_pos in blocks:
		positions.append(Vector2(
			round(block_pos.x * cos(offsetRot*PI/2) - block_pos.y * sin(offsetRot*PI/2)) + offsetX,
			round(block_pos.x * sin(offsetRot*PI/2) + block_pos.y * cos(offsetRot*PI/2)) + offsetY
		))
	
	return positions

func check_for_clears():
	var points = 0
	var pos_to_delete = []
	
	for i in range(width):
		var is_column_complete = true
		var column = []
		
		for j in range(height):
			column.append(Vector2(i, j))
			if !(Vector2(i, j) in square_positions):
				is_column_complete = false
				break
		
		if is_column_complete:
			points += 1
			pos_to_delete.append_array(column)
	
	for j in range(height):
		var is_row_complete = true
		var row = []
		
		for i in range(width):
			row.append(Vector2(i, j))
			if !(Vector2(i, j) in square_positions):
				is_row_complete = false
				break
		
		if is_row_complete:
			points += 1
			pos_to_delete.append_array(row)
	
	for pos in pos_to_delete:
		if pos in square_positions:
			var index = square_positions.find(pos)
			squares[index].queue_free()
			square_positions.remove(index)
			squares.remove(index)
