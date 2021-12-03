extends Area2D

const PowerupSound = preload("res://Effects/PowerupSound.tscn")

func _ready():
	$Timer.start(120)
	
func _process(delta):
	if $Timer.time_left <= 2:
		$AnimationPlayer.play("Blink")

func _on_Powerup_body_entered(body):
	var powerupSound = PowerupSound.instance()
	get_parent().call_deferred("add_child", powerupSound)
	queue_free()


func _on_Timer_timeout():
	queue_free()
