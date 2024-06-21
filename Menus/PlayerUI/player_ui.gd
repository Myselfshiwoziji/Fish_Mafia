extends Control


func _process(delta):
	$HPBar.value = Global.p1_player_hp
	$BubbleBar.value = Global.p1_player_bubbles
	$Score.text = "Score: " + str(Global.p1_player_score)

