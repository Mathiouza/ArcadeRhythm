tool
extends Node2D

export(bool) var selected = false setget set_selected

const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var current_letter = 0

func set_selected(new_value):
	selected = new_value
	
	if $ArrowBottom != null:
		$ArrowBottom.visible = selected
		$ArrowTop.visible = selected

func _process(_delta):
	if !Engine.editor_hint && selected:
		if Input.is_action_just_pressed("0up"):
			current_letter = (current_letter - 1 + 26) % 26
			$ArrowTopTween.stop_all()
			$ArrowTopTween.interpolate_property($ArrowTop, "rect_position", $ArrowTop.rect_position, $ArrowTop.rect_position - Vector2(0, 10), .05)
			$ArrowTopTween.interpolate_property($ArrowTop, "rect_position", $ArrowTop.rect_position - Vector2(0, 10), $ArrowTop.rect_position, .05)
			$ArrowTopTween.start()
			update_label() 
		
		if Input.is_action_just_pressed("0down"):
			current_letter = (current_letter + 1) % 26
			$ArrowBottomTween.stop_all()
			$ArrowBottomTween.interpolate_property($ArrowBottom, "rect_position", $ArrowBottom.rect_position, $ArrowBottom.rect_position + Vector2(0, 10), .05)
			$ArrowBottomTween.interpolate_property($ArrowBottom, "rect_position", $ArrowBottom.rect_position + Vector2(0, 10), $ArrowBottom.rect_position, .05)
			$ArrowBottomTween.start()
			update_label()

func update_label(letter_index = -1):
	current_letter = current_letter if letter_index == -1 else letter_index
	$Letter.text = letters[current_letter]

func get_character() -> String:
	return $Letter.text
