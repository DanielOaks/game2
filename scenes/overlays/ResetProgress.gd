extends CanvasLayer

## Whether resetting the game by holding down the start/escape button takes time.
var resetTakesTime := false
var resetAlreadyHappenedThisPress := false
var resetPressedLastFrame := false
var resetPressedTime: float = 0
var resetPressedRequires: float = 1.5

func start_taking_time():
	resetTakesTime = true

func stop_taking_time():
	resetTakesTime = false
	update_progress_shown(false)

func _ready():
	update_progress_shown(false)

func _process(delta):
	if not resetTakesTime:
		resetAlreadyHappenedThisPress = false
		if Input.is_action_just_pressed("restart"):
			get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		return

	# reset does take time
	var resetPressedThisFrame = Input.is_action_pressed("restart")
	if resetPressedThisFrame:
		if resetAlreadyHappenedThisPress:
			return
		resetPressedTime += delta
		update_progress_value()
		if resetPressedTime >= resetPressedRequires:
			get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
			resetAlreadyHappenedThisPress = true
			update_progress_shown(false)

	if resetPressedLastFrame != resetPressedThisFrame:
		resetAlreadyHappenedThisPress = false
		resetPressedTime = 0
		update_progress_shown(resetPressedThisFrame)

	resetPressedLastFrame = resetPressedThisFrame

func update_progress_shown(now_showing: bool):
	visible = false
	
	if not resetTakesTime:
		return
	
	if resetAlreadyHappenedThisPress:
		return

	if not now_showing:
		return

	visible = true

func update_progress_value():
	$ProgressBar.value = min(100, (resetPressedTime / resetPressedRequires) * 100)
