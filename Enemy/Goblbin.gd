extends KinematicBody2D
## goblbin tthey r the evil small dudes

export var MAX_SPEED = 50
export var ACCELERATION = 500
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

#likelihood of dropping different powerups
var HEALTH_LIKELIHOOD = 5
var MAX_HEALTH_LIKELIHOOD = 1
var RAPID_FIRE_LIKELIHOOD = 1

enum {
	MOVE,
	ATTACK
}
var state = MOVE
var velocity = Vector2.ZERO

func _ready():
	animationTree.active = true

## movement, follows player and attacks when close enough
func _physics_process(delta):
	var player = $PlayerPunchZone.player
	match state:
		MOVE:
			move_state(delta, player)
		ATTACK:
			attack_state(player)
	# soft collision
	if $GoblbinDetector.is_colliding():
		velocity += $GoblbinDetector.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)


## function for moving toward the player until the player is within attackrange
func move_state(delta, attackPlayer):
	var player = $PlayerDetectionZone.player
	if player != null:
		animationState.travel("Move")
		# gets the direction to the player, so we can move to them
		var toPlayer = global_position.direction_to(player.global_position).normalized()
		velocity = velocity.move_toward(MAX_SPEED * toPlayer, ACCELERATION * delta)
		# gives the direction to player to the blend positions, so goblin is looking the right way
		# (currently does nothing, but is useful if i add directional animations later on
		animationTree.set("parameters/Move/blend_position", toPlayer)
		animationTree.set("parameters/Idle/blend_position", toPlayer)
		animationTree.set("parameters/Attack/blend_position", toPlayer)
		$Sprite.flip_h = toPlayer.x > 0 # flips sprite depending on player location
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	# checks if the player is within playerpunchzone and attacks if they are
	if attackPlayer != null:
			state = ATTACK


## function for attacking the player
func attack_state(player):
	if player != null:
		# rotates the goblbin's hitbox so its actually facing the player
		$HitboxPivot.rotation = get_angle_to(player.global_position) + 180
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func _on_Hurtbox_area_entered(area):
	$Stats.health -= area.damage

func _on_Stats_health_zero():
	KillCount.addKill() # adds a kill to the killcounter
	spawn_powerups() # spawns powerups
	queue_free()


## function for spawning powerups using [method powerup] and the likelihood variables.
func spawn_powerups():
	powerup("res://Powerups/PowerupHealth.tscn", HEALTH_LIKELIHOOD)
	powerup("res://Powerups/PowerupMaxHealth.tscn", MAX_HEALTH_LIKELIHOOD)
	powerup("res://Powerups/PowerupRapidFire.tscn", RAPID_FIRE_LIKELIHOOD)


## function for spawning a powerup, given a powerup and a string
func powerup(powerupString, likelihood):
	if rand_range(0,100) <= likelihood:
		var powerup = load(powerupString).instance()
		get_parent().call_deferred("add_child", powerup)
		powerup.set_deferred("global_position", global_position)

func attack_finished():
	state = MOVE
