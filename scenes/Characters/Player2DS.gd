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
var has_double_jumped : bool = false
var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air : bool = false
var was_on_wall : bool = false
var moving_into_wall : bool = false
var can_still_jump : int = 0
var last_direction : Vector2 = Vector2.ZERO

func _process(_delta):
	$AnimatedSprite2D.material.set_shader_parameter("paletteNumber", game_data.current_vibe_i)

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	moving_into_wall = (direction.x > 0 && get_wall_normal().x < 0) or (direction.x < 0 && get_wall_normal().x > 0)
	
	if is_on_wall() and moving_into_wall and not is_on_floor():
		$StateChart.send_event("turn_right" if get_wall_normal().x > 0 else "turn_left")

	# Add the gravity and set jump animations
	var this_wall_slide_velocity = WALL_SLIDE_VELOCITY * delta
	if is_on_floor():
		has_double_jumped = false
		if was_in_air:
			$AnimatedSprite2D.play("jump_land")
			animation_locked = true
		was_in_air = false
		can_still_jump = FRAMES_TO_ALLOW_JUMPING_AFTER_LEAVING_LEDGE
	elif is_on_wall() and velocity.y > 0 and moving_into_wall:
		velocity.y = this_wall_slide_velocity
		was_in_air = true
		animation_locked = false
		was_on_wall = true
	else:
		velocity.y += gravity * delta
		was_in_air = true
		
	if can_still_jump > 0:
		can_still_jump -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction and is_on_floor():
		velocity.x = direction.x * SPEED
		if direction.x != 0:
			$StateChart.send_event("face_right" if direction.x > 0 else "face_left")
		if false: #(last_direction.x < 0 and direction.x > 0) or (last_direction.x > 0 and direction.x < 1):
			$AnimatedSprite2D.play("turnaround")
			animation_locked = true
	elif direction and not is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED / 8)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or can_still_jump > 0:
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump_start")
			if not is_on_wall():
				animation_locked = true
			can_still_jump = 0
		elif is_on_wall():
			has_double_jumped = false
			velocity.y = JUMP_VELOCITY
			if get_wall_normal().x > 0:
				velocity.x = WALL_JUMP_X_VELOCITY
				direction.x = 1
			else:
				velocity.x = -WALL_JUMP_X_VELOCITY
				direction.x = -1
			update_facing_direction()
			can_still_jump = 0
		elif has_double_jumped == false:
			# if we're already moving down our double jump would get cancelled-out by gravity...
			#  that feels bad, so just do this
			if velocity.y > 0:
				velocity.y = DOUBLE_JUMP_VELOCITY
			else:
				velocity.y += DOUBLE_JUMP_VELOCITY
			has_double_jumped = true
			can_still_jump = 0

	move_and_slide()
	update_animation()
	if is_on_floor() or is_on_wall() or was_on_wall:
		update_facing_direction()

func update_animation():
	if animation_locked:
		return
	
	if is_on_floor():
		if direction.x == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	elif is_on_wall() and moving_into_wall:
		$AnimatedSprite2D.play("wallgrab")
	else:
		if velocity.y < -JUMP_WEIGHTLESS_VELOCITY:
			$AnimatedSprite2D.play("jump_going_up")
		elif velocity.y > JUMP_WEIGHTLESS_VELOCITY:
			if $AnimatedSprite2D.animation != "jump_going_down_loop":
				$AnimatedSprite2D.play("jump_going_down")
		else:
			$AnimatedSprite2D.play("jump_weightless")

func update_facing_direction():
	# correct offsets for wall slides
	if is_on_wall() and moving_into_wall and not is_on_floor():
		if get_wall_normal().x < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.offset.x = -11
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.offset.x = -13
		return
	
	# fix direction once we leave wall
	if was_on_wall:
		direction.x = get_wall_normal().x
		was_on_wall = false
		
	# not on wall, not wall sliding
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = -24
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = 0

func _on_animation_finished():
	var animation = $AnimatedSprite2D.animation
	if animation == "jump_start" or animation == "turnaround":
		animation_locked = false
	elif animation == "jump_going_down":
		$AnimatedSprite2D.play("jump_going_down_loop")
	elif animation == "jump_land":
		$AnimatedSprite2D.play("idle")
		animation_locked = false

func _on_facing_right(event):
	pass

func _on_facing_left(event):
	pass



