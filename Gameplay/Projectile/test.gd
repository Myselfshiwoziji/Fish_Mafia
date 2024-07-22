extends Node2D
@export var projectile_scene : PackedScene
@export var projectile_speed = 2000
@export var current_owner = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
func destroy():
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += projectile_speed * delta * direction


func _on_body_entered(body):
	if body.name == "Stage":
		queue_free()
	elif body.name != str(current_owner) && Global.Players[body.name.to_int()]["invulnerable"] == false:
			Global.Players[body.name.to_int()]["hp"] -= 40
			queue_free()
	#
	#if str(body.name) != str(current_owner):
		#print("hi")
		#queue_free()
		#pass;
		#
	#

