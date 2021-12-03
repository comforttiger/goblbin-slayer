extends KinematicBody2D
## bullet. goes pew pew and KILLS the bAD GUYS!!!

export var SPEED = 300
var velocity = Vector2.ZERO

func _ready():
	$Timer.start(5)
	

## makes the thing move towards the way the bullet is rotated
func _physics_process(_delta):
	velocity = Vector2(1,0).rotated(rotation) * SPEED
	velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	queue_free()


func _on_Hitbox_area_entered(_area):
	queue_free()
