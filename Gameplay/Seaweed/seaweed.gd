extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hitbox_body_entered(body):
	if body.name.to_int() > 1 and not Global.Players[body.name.to_int()]["bubbles"] == 0:
		print("HI")
		Global.Players[body.name.to_int()]["score"] += Global.Players[body.name.to_int()]["bubbles"] * 2
		Global.Global.Players[body.name.to_int()]["bubbles"] = 0
