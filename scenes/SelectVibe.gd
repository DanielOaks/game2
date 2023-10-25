extends Control

@onready var game_data: GameData = get_node("/root/GameData")
@onready var reset_progress = get_node("/root/ResetProgress")

@onready var menu: Menu = $MarginContainer/VBoxContainer/Menu
var menuLabelSettings: LabelSettings = preload("res://assets/game2/labels/main_menu.tres")

@onready var vibe_description = $MarginContainer/VBoxContainer/MarginContainer/VibeDescription

var vibeNameToIndex = {}

func _ready():
	for i in game_data.VIBES.size():
		var vibe: Vibe = game_data.VIBES[i]
		
		# store the vibe index so we can set them later
		vibeNameToIndex[vibe.name.to_lower()] = i
		
		# add a menu entry for this vibe
		var thisLabel = Label.new()
		thisLabel.text = vibe.name
		thisLabel.label_settings = menuLabelSettings
		menu.add_child(thisLabel)
	
	# make the menu recognise the new entries
	menu.configure_focus()

func _on_menu_actioned(action: String):
	var i = vibeNameToIndex[action]
	game_data.set_vibe_to(i)
	game_data.lock_vibe()

	reset_progress.start_taking_time()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/Intro.tscn")

func _on_menu_selection_changed(index: int):
	var vibe: Vibe = game_data.VIBES[index]
	vibe_description.text = vibe.tagline
