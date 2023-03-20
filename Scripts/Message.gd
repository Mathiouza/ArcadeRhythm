tool
extends Node2D

export(String) var text setget set_text

onready var label = $Label

func set_text(new_value):
	text = new_value
	
	if label != null:
		label.text = text

func start_animation(text):
	set_text(text)
	$Tween.stop_all()
	$Tween2.stop_all()
	$Tween.interpolate_property(self, "scale", Vector2(2, 2), Vector2(1, 1), .4, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween2.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), .2, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_callback(self, 1, "end_animation")
	$Tween.start()
	$Tween2.start()

func end_animation():
	$Tween2.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween2.start()
