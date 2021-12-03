extends Control
## displays the health of the player

onready var emptyHearts = $HealthEmpty
onready var fullHearts = $HealthFull

func _ready():
	emptyHearts.rect_size.x = PlayerStats.max_health * 16
	fullHearts.rect_size.x = PlayerStats.health * 16
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed",self, "update_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "update_max_hearts")

func update_hearts(newHearts):
	if emptyHearts != null:
		fullHearts.rect_size.x = newHearts * 16

func update_max_hearts(newMaxHearts):
	if fullHearts != null:
		emptyHearts.rect_size.x = newMaxHearts * 16
