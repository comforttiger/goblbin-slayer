extends "res://Powerups/Powerup.gd"



func _on_PowerupRapidFire_body_entered(body):
	PlayerStats.powerup_rapid_fire(PlayerStats.fire_rate, 5)
