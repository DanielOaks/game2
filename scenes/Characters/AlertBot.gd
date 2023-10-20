extends CharacterBody3D

@onready var state: StateChart = $StateChart

@export var target: Node3D = null
var wander_target: Vector3 = Vector3.ZERO
var look_at_target: Vector3 = Vector3.ZERO

## How far away to wander, in units.
@export var wander_distance: float = 10

## How often to choose a new wander target.
@export var refresh_wander_target_seconds: float = 5
var next_wander_target_refresh: float = 0

@export var speed = 3.0
@export var accel = 10.0

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_reach_player := false

func _ready():
	#nav.debug_enabled = true
	pass

# see https://github.com/godotengine/godot-proposals/issues/1731
# maybe this can be done nicer in the future :pray: :hands-raised:
func new_direction() -> Vector2:
	var new_dir: = Vector2()
	new_dir.x = randf_range(-1, 1)
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func xy(vec: Vector3) -> Vector2:
	return Vector2(vec.x, vec.y)

func _physics_process(delta):
	var look_target_this_frame: Vector3 = target.position
	
	# refresh wander target
	next_wander_target_refresh -= delta
	if next_wander_target_refresh <= 0:
		# reset time
		next_wander_target_refresh = refresh_wander_target_seconds
		
		# choose a new wander target.
		# note, on the edges of the navmesh, it may *look like* the wander distance is lower than
		#  this value. what's really happening is that a wander target outside the navmesh is being
		#  chosen, and the bot can only walk to the closest point. this is fine!
		var wander_dir := new_direction() * wander_distance
		wander_target = position
		wander_target.x += wander_dir.x
		wander_target.y += wander_dir.y
		look_at_target = position
		look_at_target.x += wander_dir.x * 2
		look_at_target.y += wander_dir.y * 2
	
	# only do navigation if the nav server is ready to give us directions!
	# see the godot docs for NavigationServer timing and physics frames
	var do_nav_this_frame = not (nav.target_position == Vector3.ZERO)
	
	# move towards the target
	nav.target_position = target.position
	
	if do_nav_this_frame and nav.is_target_reachable():
		# going towards player
		if not can_reach_player:
			can_reach_player = true
			state.send_event("sees player")
	elif do_nav_this_frame and not nav.is_target_reachable():
		# or towards our wander target
		if can_reach_player:
			can_reach_player = false
			state.send_event("cannot see player")
		
		nav.target_position = wander_target
		look_target_this_frame = look_at_target

	if do_nav_this_frame:
		var direction = Vector3()
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
	else:
		# stop moving
		velocity = velocity.lerp(Vector3.ZERO, accel * delta)
	
	# rotate towards the nav target
	look_target_this_frame.y = position.y
	look_at(look_target_this_frame)
	
	move_and_slide()

func _on_staring_at_target_processing(_delta):
	$SpotLight3D.light_color = "#FF0000"

func _on_wandering_processing(_delta):
	$SpotLight3D.light_color = "#FFFFFF"
