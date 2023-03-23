extends Control

func _on_Splashscreen_end():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("Splashscreen_end")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Splashscreen_end":
		$Splashscreen.queue_free()
