tool
extends Node2D

signal gameover
signal music_level(music_level, forced_level)

var Piece = preload("res://Scenes/Piece.tscn")
var Square = preload("res://Scenes/Square.tscn")

enum SHAPE {L3 = 0, I2 = 1, I3 = 2, S2 = 3, C = 4}

const shapes = [
	[
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 1),
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
		Vector2(1, 1),
	],
	[
		Vector2(0, 0),
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(1, 0)
	]
]

export var controller = 0 setget set_controller
export var width = 6
export var height = 6

var current_piece : Piece
var next_piece : Piece
var squares = []

var current_beat = 0
var number_of_beats = 6

var level_thresholds = [
	1000, 3000, 5000, 7000, 10000, 
	13000, 16000, 18000, 20000, 
	27500, 35000, 42500, 50000, 
	60000, 70000, 80000, 90000, 
	110000, 130000, 150000
]
var level_actions = [
	"beat", "beat", "beat", "beat", "music", 
	"beat", "beat", "beat", "music", 
	"beat", "beat", "beat", "music", 
	"beat", "beat", "beat", "music", 
	"beat", "beat", "beat"
]
var level_colors = [
	Color("#5de04f"),
	Color("#9dde43"),
	Color("#bfde43"),
	Color("#ded343"),
	Color("#d9ae30"),
	Color("#d1802e"),
	Color("#d1592e"),
]
export var not_placeable_color = Color(0.62, 0.0124, 0.0124)
var score = 0
var actual_level = 1
var forced_level = 1

var square_positions: PoolVector2Array = []

var active = false

func _ready():
	if !Engine.editor_hint:
		randomize()
		
		$LevelsContainer.current_beat = current_beat + 1
		place()
		set_score(0)

func update_display_beat():
	if current_beat >= $LevelsContainer.get_number_of_beats():
		force_placement()
		current_beat = 0
	
	$LevelsContainer.current_beat = current_beat + 1

func _process(_delta):
	if !Engine.editor_hint && active:
		if check_for_placement(current_piece.x, current_piece.y, current_piece.rot, current_piece.square_positions):
			current_piece.modulate = Color(1, 1, 1)
		else:
			current_piece.modulate = not_placeable_color
			
		if Input.is_action_just_pressed(str(controller)+"up") && check_for_edges(current_piece.x, current_piece.y-1, current_piece.rot, current_piece.square_positions):
			current_piece.move(0, -1)
		
		if Input.is_action_just_pressed(str(controller)+"right") && check_for_edges(current_piece.x+1, current_piece.y, current_piece.rot, current_piece.square_positions):
			current_piece.move(1, 0)
		
		if Input.is_action_just_pressed(str(controller)+"down") && check_for_edges(current_piece.x, current_piece.y+1, current_piece.rot, current_piece.square_positions):
			current_piece.move(0, 1)
		
		if Input.is_action_just_pressed(str(controller)+"left") && check_for_edges(current_piece.x-1, current_piece.y, current_piece.rot, current_piece.square_positions):
			current_piece.move(-1, 0)
		
		if Input.is_action_just_pressed(str(controller)+"red1") && check_for_edges(current_piece.x, current_piece.y, current_piece.rot+1, current_piece.square_positions):
			current_piece.turn(true)
		
		if Input.is_action_just_pressed(str(controller)+"red2") && check_for_edges(current_piece.x, current_piece.y, current_piece.rot-1, current_piece.square_positions):
			current_piece.turn(false)
		
		if Input.is_action_just_pressed(str(controller)+"yellow1") or Input.is_action_just_pressed(str(controller)+"yellow2"):
			if check_for_placement(current_piece.x, current_piece.y, current_piece.rot, current_piece.square_positions):
				place()
				current_beat = 0
				update_display_beat()
			else:
				current_piece.wrong_placement_animation()

func reset():
	actual_level = 1
	forced_level = 1
	current_beat = 0
	number_of_beats = 7
	if current_piece != null:
		current_piece.queue_free()
	current_piece = null
	if next_piece != null:
		next_piece.queue_free()
	next_piece = null
	for i in squares:
		if weakref(i).get_ref():
			i.queue_free()
	squares = []
	square_positions = []
	$LevelsContainer.current_beat = current_beat + 1
	place()
	set_score(0)
	$HeartsContainer.lives = 3
	$LevelsContainer.level = 1
	$Message.reset()

func play():
	active = true

func place():
	if current_piece != null:
		var positions = current_piece.get_block_positions()
		
		for block_pos in positions:
			square_positions.append(block_pos)
			
			var new_square = Square.instance()
			new_square.color = Color(0.5, 0.5, 0.5)
			new_square.x = block_pos.x
			new_square.y = block_pos.y
			squares.append(new_square)
			$"%BlocksContainer".add_child(new_square)
		
		check_for_clears()
		
		current_piece.queue_free()
	
	var blocks = shapes[randi() % SHAPE.size()]
	
	if next_piece != null:
		blocks = next_piece.square_positions
		next_piece.queue_free()
	
	next_piece = Piece.instance()
	next_piece.color = level_colors[min(actual_level-1, level_colors.size()-1)]
	next_piece.square_positions = shapes[randi() % SHAPE.size()]
	$NextPieceContainer.add_child(next_piece)
	
	current_piece = Piece.instance()
	
	current_piece.x = 2
	current_piece.y = 2
	current_piece.rot = 0
	current_piece.square_positions = blocks
	current_piece.color = level_colors[min(actual_level-1, level_colors.size()-1)]
	
	add_child(current_piece)
	
	set_score(score + 10)

func force_placement():
	if !check_for_placement(current_piece.x, current_piece.y, current_piece.rot, current_piece.square_positions):
		$HeartsContainer.lives -= 1
		hit_animation()
		if $HeartsContainer.lives == 0:
			emit_signal("gameover")
			active = false
		else:
			square_positions = []
			squares = []
	else:
		place()

func hit_animation():
	for square in squares:
		square.fall()

func check_for_placement(offsetX, offsetY, offsetRot, blocks) -> bool:
	var positions = get_block_positions_on_terrain(offsetX, offsetY, offsetRot, blocks)
	
	for block_pos in positions:
		if block_pos in square_positions || block_pos.x < 0 || block_pos.y < 0 || block_pos.x >= width || block_pos.y >= height:
			return false
	
	return true

func check_for_edges(offsetX, offsetY, offsetRot, blocks) -> bool:
	var positions = get_block_positions_on_terrain(offsetX, offsetY, offsetRot, blocks)
	
	for block_pos in positions:
		if block_pos.x < 0 || block_pos.y < 0 || block_pos.x >= width || block_pos.y >= height:
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
	
	var actualPoints = 0
	
	for i in points:
		match i+1:
			1: actualPoints += 1000
			2: actualPoints += 2000
			3: actualPoints += 4000
			4: actualPoints += 6000
	
	set_score(score + actualPoints)

func pulsate():
	if active:
		if current_piece != null:
			current_piece.pulsate()
		current_beat += 1
		update_display_beat()

func set_controller(new_controller):
	controller = new_controller
	if controller == 0:
		$LevelsContainer.position = Vector2(-16, 0)
		$HeartsContainer.position = Vector2(116, 19)
	else:
		$LevelsContainer.position = Vector2(6*16+16, 0)
		$HeartsContainer.position = Vector2(-20, 19)

func set_score(new_score):
	score = new_score
	
	var i = 0
	for threshold in level_thresholds:
		if score >= threshold && actual_level <= i+1:
			set_level(actual_level + 1)
			break
		i += 1
	
	$ScoreNumber.score = score

func set_level(new_level):
	if new_level > actual_level:
		$Message.start_animation("LEVEL UP!")
	
	actual_level = new_level
	
	current_piece.color = level_colors
	next_piece.color = level_colors
	
	if actual_level > forced_level:
		forced_level = actual_level
		
		level_up()

func set_forced_level(new_level):
	forced_level = new_level
	
	if forced_level > actual_level:
		level_up()

func level_up():
	var beat_level = 1
	var music_level = 1
	
	var i = 1
	for action in level_actions:
		if i == forced_level:
			break
		
		if action == "beat":
			beat_level += 1
		else:
			beat_level = 1
			music_level += 1
		i += 1
	
	emit_signal("music_level", music_level, forced_level)
	
	$LevelsContainer.level = beat_level
