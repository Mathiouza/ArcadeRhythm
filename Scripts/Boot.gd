tool
extends Control

export(float) var curvature = 0 setget set_curvature
export(float) var brillance = 0 setget set_brillance
export(float) var red = 0 setget set_red
export(bool) var is_white_shiny = true setget set_white_shiny

onready var viewport_container = $ViewportContainer

func _ready():
	if !Engine.editor_hint:
		$AnimationPlayer.play("Splashscreen")

func set_curvature(new_curvature):
	curvature = new_curvature
	
	if viewport_container != null:
		viewport_container.material.set_shader_param("curvature", Vector2(curvature, curvature))

func set_brillance(new_brillance):
	brillance = new_brillance
	
	if viewport_container != null:
		viewport_container.material.set_shader_param("brillance", brillance)

func set_red(new_red):
	red = new_red
	
	if viewport_container != null:
		viewport_container.material.set_shader_param("red", red)

func set_white_shiny(new_value):
	is_white_shiny = new_value
	
	if viewport_container != null:
		viewport_container.material.set_shader_param("isWhiteShiny", is_white_shiny)

func _on_AnimationPlayer_animation_finished(anim_name):
	if !Engine.editor_hint:
		if anim_name == "Splashscreen":
			$AnimationPlayer.play("RESET")
			$AnimationPlayer.play("Splashscreen_end")
		
		if anim_name == "Splashscreen_end":
			$ViewportContainer/Viewport/SplashContainer.queue_free()
			$ViewportContainer/Viewport/GameContainer/Titlescreen.focus()

