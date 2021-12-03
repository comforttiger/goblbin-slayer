extends Sprite

func _ready():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
