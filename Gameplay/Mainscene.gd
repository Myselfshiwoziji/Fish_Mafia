extends Node2D

var bubble_scene = preload("res://Gameplay/Bubbles/Bubble.tscn")
@export var player_scene : PackedScene

func spawn_bubble(loc_id):
	var bubble = bubble_scene.instantiate()
	var node = get_node("Bubble" + str(loc_id))
	bubble.position = node.position
	bubble.name = "Bubble" + str(loc_id) + "-" + str(randf())
	call_deferred("add_child",bubble)


func _ready():
	$Intromusic.play()
	get_tree().paused = true
	
	await(get_tree().create_timer(3).timeout)
	
	get_tree().paused = false
	$BubbleSpawnTimer.start()
	camera($Stage)
	
	#Multiplayer stuff (Dont touch pls)
	for i in Global.Players:
		var CurrentPlayer = player_scene.instantiate()
		CurrentPlayer.name = str(Global.Players[i].id)
		add_child(CurrentPlayer)
		spawn(CurrentPlayer)
		camera(CurrentPlayer)


func spawn(object):
	var id = floor(randf_range(1, 5))
	var SpawnLocation = get_node("PlayerSpawnPosition" + str(id))
	object.position = SpawnLocation.position

func camera(player_id):
	$Camera.add_target(player_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.time_left = $GameTimer.time_left
	$Time.text = "Time remaning: " + str(round($GameTimer.time_left))



func _on_bubble_spawn_timer_timeout():
	spawn_bubble(1)
	spawn_bubble(2)
	spawn_bubble(3)
	spawn_bubble(4)
	spawn_bubble(5)
	$BubbleSpawnTimer.wait_time = randf_range(5, 10) 
	$BubbleSpawnTimer.start()


func _on_game_timer_timeout():
	get_tree().paused = true
	$Time.text = "Time is up!"
	
	await(get_tree().create_timer(3).timeout)
	
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://Menus/EndScene/EndScene.tscn")
