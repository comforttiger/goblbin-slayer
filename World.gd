extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		PlayerStats.reload()
		KillCount.reload()
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
