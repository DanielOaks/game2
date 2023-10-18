extends Control

func _on_settings_menu_close_menu():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
