extends Node2D
## for handling the stats of enemies and player

export(int) var max_health = 2 setget set_max_health
onready var health = max_health setget set_health
var original_max_health = 0

signal max_health_changed(max_health)
signal health_changed(health)
signal health_zero

func _ready():
	original_max_health = max_health

func set_max_health(value):
	max_health = value
	if health != null:
		health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	if value <= max_health:
		health = value
		emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("health_zero")


## function for reloading, when the game restarts. (necessary for playerstats, since theyre global)
func reload():
	max_health = original_max_health
	health = max_health
