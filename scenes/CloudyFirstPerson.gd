extends Node3D

@onready var stage = $stage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stage.rotate_y(.04 * delta)
