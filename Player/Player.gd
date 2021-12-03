extends KinematicBody2D
## player class :)

## the speed at which the player will reach its max speed (should be higher than max speed)
export var ACCELERATION = 500
## the max speed
export var MAX_SPEED = 80
## the player's dash speed. player go nyoom
export var DASH_SPEED = 500

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox/CollisionShape2D
onready var invincibility = $Hurtbox
onready var invincibilityFrames = $BlinkAnimationPlayer
const Trail = preload("res://Player/DashTrail.tscn")

enum {
	MOVE,
	DASH,
}
var velocity = Vector2.ZERO
var dash_vector = Vector2.DOWN
var state = MOVE
var controller = false


func _ready():
	animationTree.active = true
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_zero", self, "queue_free") # makes the player die if they are killed

## physics process stuff. velocity gets updated by [method move_state] and [method dash_state], depending on
## whether the player is currently dashing or not. also lets the player call [method shoot]
func _physics_process(delta):
	if Input.is_action_just_pressed("shoot_controller"):
		controller = true
	if Input.is_action_just_pressed("shoot"):
		controller = false
	# gets the player's mouse position, so we know where to look.
	var look_vector = Vector2.ZERO
	if controller == false:
		look_vector = get_global_mouse_position() - global_position
		look_vector = look_vector.normalized()
	else:
		look_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		look_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		if look_vector != Vector2.ZERO:
			$Gun.shoot(look_vector)
	# sets the player's blend position in the animation tree to be always looking towards the mouse
	animationTree.set("parameters/Move/blend_position", look_vector)
	animationTree.set("parameters/Idle/blend_position", look_vector)
	animationTree.set("parameters/Dash/blend_position", look_vector)
	$Sprite.flip_h = look_vector.x < -0.7 # for the left-facing sprites, we just flip the sprite horizontally.
	match state:
		MOVE:
			move_state(delta)
		DASH:
			dash_state()
	velocity = move_and_slide(velocity)
	if (Input.is_action_pressed("shoot") || Input.is_action_pressed("shoot_controller")):
		$Gun.shoot(look_vector) # shoots


## move state. controls the player's movement through player's input
func move_state(delta):
	# gets input vector depending on input
	var input_vector = Vector2.ZERO
	if controller == false:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	else:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		dash_vector = input_vector # set dash_vector to equal input_vector, so we can dash in that direction
		animationState.travel("Move") # run animation
		velocity = velocity.move_toward(MAX_SPEED * input_vector, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	# only let the player dash if they're not invincible. (meaning they've either recently dashed or have been hit
	if Input.is_action_just_pressed("dash") && $BlinkAnimationPlayer.current_animation != "StartDash":
		$DashSound.play()
		state = DASH


## dash state. lets the player move very quickly in one direction and gives a short frame of invincibility
func dash_state():
	create_trail() # creates a trail several times during dodge
	invincibility.invincibility_start(0.4)
	velocity = dash_vector * DASH_SPEED
	animationState.travel("Dash")

## ends the dash by slowing down the speed a bit and then going to MOVE
func dash_done():
	velocity = velocity * 0.8
	state = MOVE


func _on_Hurtbox_area_entered(area):
	PlayerStats.health -= area.damage


func _on_Hurtbox_invincibility_started():
	hurtbox.set_deferred("disabled", true)
	if state == DASH:
		invincibilityFrames.play("StartDash")
	else:
		invincibilityFrames.play("StartWhite")


func _on_Hurtbox_invincibility_ended():
	hurtbox.set_deferred("disabled", false)
	invincibilityFrames.play("Stop")


func create_trail():
	var trail = Trail.instance()
	get_parent().add_child(trail)
	trail.global_position = global_position
	trail.texture = $Sprite.texture
	trail.frame = $Sprite.frame
