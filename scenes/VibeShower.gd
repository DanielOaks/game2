extends Label

var game_data: GameData

func _ready():
	game_data = get_node("/root/GameData")
	game_data.connect("vibe_changed", update_text)
	update_text(game_data.current_vibe)

func update_text(new_vibe: Vibe):
	self.text = "Vibe: " + new_vibe.name
