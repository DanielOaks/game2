extends Node3D

@onready var background_music = get_node("/root/BackgroundMusic")
@onready var game_data: GameData = get_node("/root/GameData")

@onready var stage = $stage

var bgMusic = preload("res://assets/game2/sound/ChillBgLoop.ogg")
@onready var player = $Player

func _ready():
	background_music.play(bgMusic)

func _process(delta):
	stage.rotate_y(.04 * delta)
	
	if player.position.y <= -50:
		get_tree().change_scene_to_file("res://scenes/ProceduralFirstPerson.tscn")
	elif game_data.should_reset_game():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
