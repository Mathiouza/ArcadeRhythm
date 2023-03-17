extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mscale = .5

func _process(delta):
	if Input.is_action_just_pressed("red1"):
		mscale += .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("1")
	
	if Input.is_action_just_pressed("red2"):
		mscale -= .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("2")
	
	if Input.is_action_just_pressed("yellow1"):
		mscale += .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("3")
	
	if Input.is_action_just_pressed("yellow2"):
		mscale -= .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("4")
	
	if Input.is_action_just_pressed("green1"):
		mscale += .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("5")
	
	if Input.is_action_just_pressed("green2"):
		mscale -= .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("6")
	
	if Input.is_action_just_pressed("blue1"):
		mscale += .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("7")
	
	if Input.is_action_just_pressed("blue2"):
		mscale -= .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("8")
	
	if Input.is_action_just_pressed("player"):
		mscale += .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("9")
	
	if Input.is_action_just_pressed("credit"):
		mscale -= .1
		$AudioStreamPlayer.pitch_scale = mscale
		print("10")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
