tool
extends Node2D

export(int, 0, 2) var active_letter = 0 setget set_active_letter
var active = false

func reset():
	set_active_letter(0)
	$LetterChoice1.update_label(0)
	$LetterChoice2.update_label(0)
	$LetterChoice3.update_label(0)

func stop():
	for child in get_children():
		child.selected = false
	active = false

func start():
	active = true
	get_child(active_letter).selected = true

func set_active_letter(new_value):
	active_letter = new_value
	
	if get_child_count() > 0:
		for child in get_children():
			child.selected = false
		get_child(active_letter).selected = true

func _process(_delta):
	if !Engine.editor_hint && active:
		if Input.is_action_just_pressed("0left"):
			set_active_letter((active_letter - 1 + 3) % 3)
		
		if Input.is_action_just_pressed("0right"):
			set_active_letter((active_letter + 1) % 3)

func get_text() -> String:
	return $LetterChoice1.get_character() + $LetterChoice2.get_character() + $LetterChoice3.get_character()
