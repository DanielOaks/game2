extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/ExampleSideScroll.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

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
	var image = Image.load_from_file(image_paths.pick_random())
	var texture = ImageTexture.create_from_image(image)
	
	var title = get_node("MarginContainer/VBoxContainer/title") as TextureRect
	title.texture = texture

func _process(delta):
	if Input.is_action_just_pressed("secret_1"):
		new_title_image()

func _on_ready():
	new_title_image()
