extends Label


func _ready():
# warning-ignore:return_value_discarded
	KillCount.connect("added_kill", self, "update_counter")

func update_counter(kills):
	text = str(kills)
