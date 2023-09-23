extends Control

@onready var game_data: GameData = get_node("/root/GameData")

func _on_menu_actioned(action: String):
	if action == "play": get_tree().change_scene_to_file("res://scenes/SelectVibe.tscn")
	if action == "play 2d": get_tree().change_scene_to_file("res://scenes/ExampleSideScroll.tscn")
	if action == "play 3d": get_tree().change_scene_to_file("res://scenes/ExampleFirstPerson.tscn")
	
	if action == "quit": get_tree().quit()

func get_all_file_paths(path):
	# ew. is there a path.join kind of function? this will break if the path doesn't have a '/' at the end :pensive:
	
	var paths = []
	
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() or file_name.ends_with(".import"):
			pass
		else:
			paths.append(path + file_name)
		file_name = dir.get_next()

	return paths

# get random title image
func new_title_image():
	var image_paths = get_all_file_paths("res://images/title-images/")
	var texture = load(image_paths.pick_random())
	
	var title = get_node("MarginContainer/VBoxContainer/title") as TextureRect
	title.texture = texture

func _process(_delta):
	if Input.is_action_just_pressed("secret_1"):
		new_title_image()

func _on_ready():
	new_title_image()
	#$MarginContainer/VBoxContainer/Menu.update_selection()
