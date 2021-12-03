extends Node2D
onready var enemySpawn = $YSort/EnemySpawn

func _ready():
	enemySpawn.pause = false

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		reload()

func reload():
	PlayerStats.reload()
	KillCount.reload()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func go_inside():
	get_tree().change_scene("res://World/Indoors.tscn")
