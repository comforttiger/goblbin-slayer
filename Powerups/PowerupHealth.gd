extends "res://Powerups/Powerup.gd"


func _on_PowerupHealth_body_entered(body):
	PlayerStats.health += 1
