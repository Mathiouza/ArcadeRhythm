tool
extends Label

export(int) var score = 0

var displayed_score = 0.0

func _process(delta):
	if displayed_score < score:
		displayed_score += max(float(score - displayed_score) * delta, 20.0 * delta)
		text = str(int(displayed_score)).pad_zeros(6)
	
	if displayed_score > score-.5:
		displayed_score = score
		text = str(int(displayed_score)).pad_zeros(6)
