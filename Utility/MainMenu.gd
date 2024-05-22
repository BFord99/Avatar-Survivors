extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Maps/TestWorld.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_ready():
	get_tree().paused = false 
