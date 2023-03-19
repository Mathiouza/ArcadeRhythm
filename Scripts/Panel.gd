tool
extends NinePatchRect

var bolt_texture = preload("res://Assets/Sprites/Bolt.png")

export(int, 0, 10000) var horizontal_bolts setget set_horizontal_bolts
export(int, 0, 10000) var vertical_bolts setget set_vertical_bolts

func set_horizontal_bolts(new_value):
	horizontal_bolts = new_value
	
	if $HorizontalBoltsContainer != null:
		for node in $HorizontalBoltsContainer.get_children():
			$HorizontalBoltsContainer.remove_child(node)
			node.queue_free()
		
		var step = (rect_size[0] - 5 - 5 - 6) / (new_value + 1)
		
		for j in 2:
			for i in range(1, new_value+1):
				var child = Sprite.new()
				child.texture = bolt_texture
				child.centered = false
				
				child.position = Vector2(5 + step * i, 5 + j * (rect_size[1] - 5 - 6 - 5))
				$HorizontalBoltsContainer.add_child(child)

func set_vertical_bolts(new_value):
	vertical_bolts = new_value
	
	if $VerticalBoltsContainer != null:
		for node in $VerticalBoltsContainer.get_children():
			$VerticalBoltsContainer.remove_child(node)
			node.queue_free()
		
		var step = (rect_size[1] - 5 - 5 - 6) / (new_value + 1)
		
		for j in 2:
			for i in range(1, new_value+1):
				var child = Sprite.new()
				child.texture = bolt_texture
				child.centered = false
				
				child.position = Vector2(5 + j * (rect_size[0] - 5 - 6 - 5), 5 + step * i)
				$VerticalBoltsContainer.add_child(child)

func _on_Panel_resized():
	set_horizontal_bolts(horizontal_bolts)
	set_vertical_bolts(vertical_bolts)
