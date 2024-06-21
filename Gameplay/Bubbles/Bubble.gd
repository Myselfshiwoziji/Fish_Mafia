extends StaticBody2D

var colliding_with_stage = true
var displace_attempts = 0

func _ready():
	modulate.a = 0.8
	
	while colliding_with_stage == true or displace_attempts > 50:
		var displacement = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		var new_position = global_position + displacement
		global_position = new_position
		
		var collision_info = move_and_collide(Vector2.ZERO)
		
		if str(collision_info) == "<Object#null>":
			colliding_with_stage = false
		
		displace_attempts += 1
	

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		if Global.p1_player_bubbles < 5:
			Global.p1_player_bubbles += 1
			queue_free()
	else:
		if Global.p2_player_bubbles < 5:
			Global.p2_player_bubbles += 1
			queue_free()
