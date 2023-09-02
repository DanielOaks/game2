extends CharacterBody2D

@export var SPEED: float = 140.0
@export var JUMP_VELOCITY: float = -200.0
@export var DOUBLE_JUMP_VELOCITY: float = -200.0
@export var JUMP_WEIGHTLESS_VELOCITY: float = 90
@export var WALL_JUMP_X_VELOCITY: float = 170
@export var WALL_SLIDE_VELOCITY: float = 4000
@export var FRAMES_TO_ALLOW_JUMPING_AFTER_LEAVING_LEDGE: int = 10

@onready var game_data: GameData = get_node("/root/GameData")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing: String = "right"
var direction: Vector2 = Vector2.ZERO
var animation_locked: bool = false
var moving_into_wall : bool = false
var update_sprite_after_next_move_and_slide: bool = false

func _process(_delta):
	$AnimatedSprite2D.material.set_shader_parameter("paletteNumber", game_data.current_vibe_i)

# these are used for dispatching events to state chart
var _is_on_floor: bool = false
var _is_on_wall: bool = false

func _ready():
	# dispatch initial events to state chart
	_is_on_floor = is_on_floor()
	$StateChart.send_event("on_floor" if _is_on_floor else "left_floor")
	_is_on_wall = is_on_wall()
	if _is_on_wall:
		$StateChart.send_event("on_wall")

func _physics_process(delta):
	# dispatch floor and wallevents to state chart
	var _is_now_on_floor = is_on_floor()
	if _is_on_floor != _is_now_on_floor:
		_is_on_floor = _is_now_on_floor
		$StateChart.send_event("on_floor" if _is_on_floor else "left_floor")

	moving_into_wall = (direction.x > 0 && get_wall_normal().x < 0) or (direction.x < 0 && get_wall_normal().x > 0)
	var _is_now_on_wall = is_on_wall() and moving_into_wall
	if _is_on_wall != _is_now_on_wall:
		_is_on_wall = _is_now_on_wall
		$StateChart.send_event("on_wall" if _is_on_wall else "left_wall")
	
	# update facing direction
	direction = Input.get_vector("left", "right", "up", "down")

	if direction and direction.x != 0:
		var now_facing = facing
		
		if is_on_floor():
			now_facing = "right" if direction.x > 0 else "left"
		elif is_on_wall() and moving_into_wall:
			now_facing = "right" if get_wall_normal().x > 0 else "left"
				
		if facing != now_facing:
			facing = now_facing
			update_sprite_flip_and_offsets()

			# $AnimatedSprite2D.play("turnaround")
			# animation_locked = true

	# Gravity
	var this_wall_slide_velocity = WALL_SLIDE_VELOCITY * delta
	if is_on_wall() and moving_into_wall and not is_on_floor and velocity.y > this_wall_slide_velocity:
		velocity.y = this_wall_slide_velocity
	else:
		velocity.y += gravity * delta

	# Apply left/right movement
	if direction and is_on_floor():
		velocity.x = direction.x * SPEED
	elif direction and not is_on_floor():
		# change speed slower in air
		velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED / 8)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		$StateChart.send_event("jump_pressed")

	move_and_slide()
	
	if update_sprite_after_next_move_and_slide:
		update_sprite_flip_and_offsets()
		update_sprite_after_next_move_and_slide = false

func update_sprite_flip_and_offsets():
	# correct offsets for wall slides
	if is_on_wall() and moving_into_wall and not is_on_floor():
		if facing == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.offset.x = -11
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.offset.x = -13
		return
	
	# not on wall, not wall sliding
	if facing == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = -24
	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = 0


# animation sprite signals
func _on_animation_finished():
	var animation = $AnimatedSprite2D.animation
	if animation == "jump_start" or animation == "turnaround":
		animation_locked = false
	elif animation == "jump_going_down":
		$AnimatedSprite2D.play("jump_going_down_loop")
	elif animation == "jump_land":
		$AnimatedSprite2D.play("idle")
		animation_locked = false

# state machine signals
func _on_floor_state_entered():
	$AnimatedSprite2D.play("jump_land")
	animation_locked = true

func _on_floor_state_processing(delta):
	if animation_locked: return

	if direction.x == 0:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("run")


func _on_in_air_processing(delta):
	if animation_locked: return
	
	if velocity.y < -JUMP_WEIGHTLESS_VELOCITY:
		$AnimatedSprite2D.play("jump_going_up")
	elif velocity.y > JUMP_WEIGHTLESS_VELOCITY:
		if $AnimatedSprite2D.animation != "jump_going_down_loop":
			$AnimatedSprite2D.play("jump_going_down")
	else:
		$AnimatedSprite2D.play("jump_weightless")


func apply_wall_jump_x_velocity():
	if get_wall_normal().x > 0:
		velocity.x = WALL_JUMP_X_VELOCITY
	else:
		velocity.x = -WALL_JUMP_X_VELOCITY

func _on_jumped_state_entered():
	velocity.y = JUMP_VELOCITY
	if is_on_wall() and moving_into_wall:
		apply_wall_jump_x_velocity()
		
		# do this on the next frame because update_sprite_flip_and_offset detects whether we are on
		#  the wall by using is_on_wall(), which is still true right now. this will run that fn()
		#  after running the move_and_slide() instead \o/
		update_sprite_after_next_move_and_slide = true
	else:
		$AnimatedSprite2D.play("jump_start")
		animation_locked = true


func _on_double_jumped_state_entered():
	# if we're already moving down our double jump would get cancelled-out by gravity...
	#  that feels bad, so just do this
	if velocity.y > 0:
		velocity.y = DOUBLE_JUMP_VELOCITY
	else:
		velocity.y += DOUBLE_JUMP_VELOCITY


func _on_wall_state_processing(delta):
	$AnimatedSprite2D.play("wallgrab")

func _on_wall_state_entered():
	# wall-slide sprites have weird offsets
	update_sprite_flip_and_offsets()

func _on_wall_state_exited():
	# wall-slide sprites have weird offsets
	update_sprite_flip_and_offsets()
