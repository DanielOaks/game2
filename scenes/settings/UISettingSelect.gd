extends HBoxContainer

signal item_selected

@onready var options = $OptionButton

func set_default_value(index):
	options.selected = options.get_item_index(index)

func _on_option_button_item_selected(index):
	emit_signal("item_selected", options.get_item_id(index), options.get_item_text(index))
