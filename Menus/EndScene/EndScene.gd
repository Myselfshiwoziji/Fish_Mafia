extends Control
var winner = "N/A"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Outro.play()
	$Background.modulate = Color(0.2, 0.2, 0.2)
	
	if Global.p1_player_score > Global.p2_player_score:
		winner = "Player 1"
		$PlayerIcon.modulate = Color(1, 1, 1)
	else:
		winner = "Player 2"
		$PlayerIcon.modulate = Color(0.7, 1, 1)
	
	if Global.p1_player_score == Global.p2_player_score:
		winner = "TIE"
		$PlayerIcon.modulate = Color(0, 0, 0)
	
	$P2Score.text = str(Global.p2_player_score)
	$P1Score.text = str(Global.p1_player_score)
	
	$Winner.text = "Winner: " + winner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_return_home_pressed():
	get_tree().change_scene_to_file("res://Menus/MainMenu/MainMenu.tscn")
