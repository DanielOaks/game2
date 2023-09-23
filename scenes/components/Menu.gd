class_name Menu extends VBoxContainer

@export var pointer: Node2D
@export var uiAudioStreamPlayer: AudioStreamPlayer2D

var buttonSound = preload("res://assets/freesound/677861__el_boss__ui-button-click.wav")

signal actioned(action: String)

func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	self.gui_input.connect(_on_gui_input)
	minimum_size_changed.connect(_on_minimum_size_changed)
	configure_focus()
	update_selection()

func _unhandled_input(event):
	if not visible: return
	
	get_viewport().set_input_as_handled()
	
	var item = get_focused_item()
	if is_instance_valid(item) and event.is_action_pressed("ui_accept"):
		emit_actioned(item)

func emit_actioned(item: Control) -> void:
	actioned.emit(item.text.to_lower())

func get_items() -> Array[Control]:
	var items: Array[Control] = []
	for child in get_children():
		if not child is Control: continue
		if "Heading" in child.name: continue
		if "Divider" in child.name: continue
		items.append(child)

	return items

func configure_focus() -> void:
	var items = get_items()
	for i in items.size():
		var item: Control = items[i]
		
		item.mouse_filter = Control.MOUSE_FILTER_PASS
		item.mouse_entered.connect(_on_mouse_entered.bind(item))
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
			item.grab_focus()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()
		
		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()

func get_focused_item() -> Control:
	var item = get_viewport().gui_get_focus_owner()
	return item if item in get_children() else null

func update_selection() -> void:
	var item = get_focused_item()
	
	if is_instance_valid(item) and is_instance_valid(pointer) and visible:
		pointer.global_position = Vector2(global_position.x - 50, item.global_position.y + item.size.y * .5 - 5)

func _on_mouse_entered(item: Control) -> void:
	if not item: return
	if not item in get_children(): return
	if item.has_focus(): return
	
	uiAudioStreamPlayer.stream = buttonSound
	uiAudioStreamPlayer.play()
	
	item.grab_focus()

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()): return
	
	emit_actioned(get_focused_item())

func _on_focus_changed(item: Control) -> void:
	if not item: return
	if not item in get_children(): return
	
	uiAudioStreamPlayer.stream = buttonSound
	uiAudioStreamPlayer.play()
	
	update_selection()

func _on_minimum_size_changed() -> void:
	update_selection()
