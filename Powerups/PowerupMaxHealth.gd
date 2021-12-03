extends "res://Powerups/Powerup.gd"
## powerup that gives +1 max heatlh

func _on_PowerupMaxHealth_body_entered(body):
	PlayerStats.max_health += 1

