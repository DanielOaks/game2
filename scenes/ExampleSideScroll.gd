extends Node2D

@onready var background_music = get_node("/root/BackgroundMusic")

var bgMusic = preload("res://assets/game2/sound/PlatformsBgLoop.ogg")

func _ready():
	background_music.play(bgMusic)
