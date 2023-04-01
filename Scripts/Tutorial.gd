extends Sprite

signal start(two_players)

var is_two_players = true

var is_player_1_ready = false
var is_player_2_ready = false

var is_active = false

func reset(two_players: bool):
	is_two_players = two_players
	
	$Beat.position.x = -39 if is_two_players else 0
	$Beat2.visible = is_two_players
	
	$Beat.color = Color("333333")
	$Beat2.color = Color("333333")
	
	is_player_1_ready = false
	is_player_2_ready = false
	
	is_active = true

func _process(delta):
	if is_active:
		if (Input.is_action_just_pressed("0blue1") ||
			Input.is_action_just_pressed("0blue2") ||
			Input.is_action_just_pressed("0red1") ||
			Input.is_action_just_pressed("0red2") ||
			Input.is_action_just_pressed("0yellow1") ||
			Input.is_action_just_pressed("0yellow2") ||
			Input.is_action_just_pressed("0green1") ||
			Input.is_action_just_pressed("0green2")):
				is_player_1_ready = !is_player_1_ready
				$Beat.color = Color("333333") if !is_player_1_ready else Color("29a852")
				if is_player_1_ready && !is_two_players || is_player_1_ready && is_player_2_ready:
					emit_signal("start", is_two_players)
					is_active = false
		
		if (Input.is_action_just_pressed("1blue1") ||
			Input.is_action_just_pressed("1blue2") ||
			Input.is_action_just_pressed("1red1") ||
			Input.is_action_just_pressed("1red2") ||
			Input.is_action_just_pressed("1yellow1") ||
			Input.is_action_just_pressed("1yellow2") ||
			Input.is_action_just_pressed("1green1") ||
			Input.is_action_just_pressed("1green2")):
				is_player_2_ready = !is_player_2_ready
				$Beat2.color = Color("333333") if !is_player_2_ready else Color("29a852")
				if is_player_1_ready && is_player_2_ready:
					emit_signal("start", is_two_players)
					is_active = false
