extends "res://Stats.gd"

var fire_rate = 1 setget set_fire_rate
var fire_rate_original = fire_rate

func set_fire_rate(value):
	fire_rate = value
	
func reload():
	fire_rate = fire_rate_original


# powerups:
func powerup_rapid_fire(fire_rate_normal, time):
	fire_rate = 0.1
	$RapidFireTimer.start(time)
	$RapidFireTimer.connect("timeout", self, "powerup_rapid_fire_ended", [fire_rate_normal])
func powerup_rapid_fire_ended(fire_rate_normal):
	fire_rate = fire_rate_normal
