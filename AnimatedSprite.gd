extends AnimatedSprite

func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "queue_free")
	frame = 0
	play("default")
