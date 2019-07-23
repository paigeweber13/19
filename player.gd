extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 1600)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 500 # pixels/sec
const JUMP_SPEED = 1100
const SIDING_CHANGE_SPEED = 10
const SHOOT_TIME_SHOW_WEAPON = 0.2

var on_floor
var linear_vel = Vector2()

var anim = ""

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func get_input():
	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
	if Input.is_action_pressed("ui_right"):
		target_speed += 1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")):
		linear_vel.y = -JUMP_SPEED
		# ($SoundJump as AudioStreamPlayer2D).play()

func process_gravity(delta):
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	on_floor = is_on_floor()
	
func process_movement(delta):
	process_gravity(delta)
	get_input()

func process_animation():
	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			$AnimatedSprite.scale.x = -1
			new_anim = "walk"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			$AnimatedSprite.scale.x = 1
			new_anim = "walk"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			$AnimatedSprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			$AnimatedSprite.scale.x = 1

		# Using "idle" as placeholder until I get new animations
		if linear_vel.y < 0:
			# new_anim = "jumping"
			new_anim = "idle"
		else:
			# new_anim = "falling"
			new_anim = "idle"

	if new_anim != anim:
		anim = new_anim
		if (anim == "idle"):
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.play(anim)

func _ready():
	$AnimatedSprite.play("walk")
	$AnimatedSprite.stop()
	pass

func _physics_process(delta):
	process_movement(delta)
	process_animation()

