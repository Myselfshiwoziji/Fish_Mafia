extends Control

func _ready():
	$Icon.modulate = Color(0.7, 1, 1)

func _process(delta):
	# P1 stuff
	$HPBar.value = Global.p2_player_hp
	$BubbleBar.value = Global.p2_player_bubbles
	$Score.text = "Score: " + str(Global.p2_player_score)
#
