extends CharacterBody3D

@export var WALK_SPEED = 5.0
@export var CROUCH_SPEED = 3.0
@export var JUMP_VELOCITY = 4.5
@export var MOVEMENT_SNAPPINESS = 10.0
@export var CROUCH_DEPTH = 0.5
@export var CROUCH_SNAPPINESS = 13.0

var direction = Vector3.ZERO
var crouching: bool = false

@onready var game_data: GameData = get_node("/root/GameData")
@onready var default_head_height: float = $Head.position.y

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * game_data.mouse_sensitivity))
		$Head.rotate_x(deg_to_rad(-event.relative.y * game_data.mouse_sensitivity))

	if event is InputEventJoypadMotion:
		# move here too
		pass

	$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# enable and disable collision shapes as needed
	if crouching != Input.is_action_pressed("crouch"):
		crouching = Input.is_action_pressed("crouch")
		
		if not crouching and $StandingRaycast.is_colliding():
			# we can't stand, sit back down
			crouching = true 
		elif crouching:
			$StandingCollisionShape.disabled = true
			$CrouchingCollisionShape.disabled = false
		else:
			$StandingCollisionShape.disabled = false
			$CrouchingCollisionShape.disabled = true
	
	# we need to get current speed and head height every frame,
	#  so that the movement and lerps work
	var current_speed = WALK_SPEED
	var new_head_height = default_head_height
	
	if crouching:
		current_speed = CROUCH_SPEED
		new_head_height -= CROUCH_DEPTH
	# elif Input.is_action_pressed("run"):
	# 	current_speed = RUN_SPEED
	
	$Head.position.y = lerp($Head.position.y, new_head_height, delta * CROUCH_SNAPPINESS)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * MOVEMENT_SNAPPINESS)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()