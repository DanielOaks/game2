extends HBoxContainer

@onready var checkbox = $CheckBox

# set default
func set_default_value(pressed: bool):
	checkbox.button_pressed = pressed

# pass through the checkbox value
signal toggled(is_button_pressed)

func _on_check_box_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)
