extends Control


func _process(delta):
	$HPBar.value = Global.Players[1]["hp"]
	$BubbleBar.value = Global.Players[1]["bubbles"]
	#$Score.text = "Score: " + str(Global.p1_player_score)
	pass;

