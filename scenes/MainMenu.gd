extends Control

@export var title_images: Array[TitleImage] = [
	load("res://assets/game2/title-images/wordart-1.tres"),
	load("res://assets/game2/title-images/wordart-2.tres"),
	load("res://assets/game2/title-images/wordart-3.tres"),
	load("res://assets/game2/title-images/wordart-4.tres"),
	load("res://assets/game2/title-images/wordart-5.tres"),
	load("res://assets/game2/title-images/wordart-6.tres"),
	load("res://assets/game2/title-images/wordart-7.tres"),
	load("res://assets/game2/title-images/wordart-8.tres"),
	load("res://assets/game2/title-images/wordart-9.tres"),
	load("res://assets/game2/title-images/wordart-10.tres"),
]

@onready var background_music = get_node("/root/BackgroundMusic")
@onready var game_data: GameData = get_node("/root/GameData")

var bgMusic = preload("res://assets/game2/sound/MainBgLoop.ogg")

func _on_menu_actioned(action: String):
	if action == "play":
		game_data.start_playtime()
		get_tree().change_scene_to_file("res://scenes/SelectVibe.tscn")
	if action == "play 2d":
		game_data.start_playtime()
		get_tree().change_scene_to_file("res://scenes/ExampleSideScroll.tscn")
	if action == "play 3d":
		game_data.start_playtime()
		get_tree().change_scene_to_file("res://scenes/DystopiaFirstPerson.tscn")

	if action == "settings": get_tree().change_scene_to_file("res://scenes/SettingsMenu.tscn")
	
	if action == "quit": get_tree().quit()

# get random title image
func new_title_image():
	var ti: TitleImage = title_images.pick_random()
	
	var title = get_node("MarginContainer/VBoxContainer/title") as TextureRect
	title.texture = ti.texture
	$BgColorRect.color = ti.background

func _process(_delta):
	if Input.is_action_just_pressed("secret_1"):
		new_title_image()

func _on_ready():
	game_data.end_playtime()
	new_title_image()
	background_music.play(bgMusic)
	#$MarginContainer/VBoxContainer/Menu.update_selection()
