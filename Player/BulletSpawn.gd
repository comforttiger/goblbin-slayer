extends Position2D

const Bullet = preload("res://Player/Bullet.tscn")

var can_shoot = true

## function that spawns a bullet at the player's position, 
## and then starts a timer so the player can't shoot immediately again
func shoot(look_vector):
	if can_shoot:
		var bullet = Bullet.instance()
		get_parent().call_deferred("add_child", bullet)
		bullet.set_deferred("global_position", global_position)
		bullet.set_deferred("rotation", look_vector.angle())
		can_shoot = false
		$Timer.start(PlayerStats.fire_rate)

func _on_Timer_timeout():
	can_shoot = true
