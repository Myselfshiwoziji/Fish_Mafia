extends Control


func _ready():
	$Intromusic.play()

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Gameplay/Mainscene.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Menus/Settings/Settings.tscn")


func _on_quit_pressed():
	get_tree().quit()
