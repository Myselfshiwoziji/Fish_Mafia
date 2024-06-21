extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hitbox_body_entered(body):
	if body.name == "Player" and not Global.p1_player_bubbles == 0:
		Global.p1_player_score += Global.p1_player_bubbles * 2
		Global.p1_player_bubbles = 0
	
	if body.name == "Player2" and not Global.p2_player_bubbles == 0:
		Global.p2_player_score += Global.p2_player_bubbles * 2
		Global.p2_player_bubbles = 0
