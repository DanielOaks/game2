extends Node2D

@onready var background_music = get_node("/root/BackgroundMusic")
@onready var game_data: GameData = get_node("/root/GameData")

@onready var player = $Player

var bgMusic = preload("res://assets/game2/sound/PlatformsBgLoop.ogg")

func _ready():
	background_music.play(bgMusic)

func _process(_delta):
	if player.position.y >= 350:
		get_tree().change_scene_to_file("res://scenes/ProceduralFirstPerson.tscn")
	elif game_data.should_reset_game():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
