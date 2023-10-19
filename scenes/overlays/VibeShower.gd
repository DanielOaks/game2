extends VBoxContainer

var game_data: GameData
var controller: Controller

func _ready():
	game_data = get_node("/root/GameData")
	game_data.connect("vibe_changed", update_text)
	game_data.connect("vibe_lock_changed", update_vibe_locked)
	update_text(game_data.current_vibe)
	
	controller = get_node("/root/Controller")
	controller.connect("controller_type_changed", update_controller)
	update_controller(controller.current)

func update_text(new_vibe: Vibe):
	$VibeName.text = new_vibe.name

func update_controller(new_controller: Controller.ControllerType):
	if game_data._vibe_locked:
		$ControllerButtons.hide()
		$KeyboardButtons.hide()
		return
	
	if new_controller == Controller.ControllerType.Gamepad:
		$ControllerButtons.show()
		$KeyboardButtons.hide()
	elif new_controller == Controller.ControllerType.KeyboardMouse:
		$ControllerButtons.hide()
		$KeyboardButtons.show()

func update_vibe_locked(now_locked: bool):
	if now_locked:
		$ControllerButtons.hide()
		$KeyboardButtons.hide()
	else:
		update_controller(controller.current)
