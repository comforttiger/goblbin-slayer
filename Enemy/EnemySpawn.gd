extends Node2D

export var canSpawnRange = [0, 5]
export var cooldownRange = [0, 30]
export var maxEnemies = 5
const Goblbin = preload("res://Enemy/Goblbin.tscn")
var canSpawn = 0

onready var topLeft = $TopLeft
onready var bottomRight = $BottomRight
var enemiesOnScreen = 0

func _ready():
	randomize()
# warning-ignore:return_value_discarded
	KillCount.connect("added_kill", self, "removeGoblbin")
	$Timer.start(1)

func _process(_delta):
	if canSpawn > 0 && enemiesOnScreen <= maxEnemies * KillCount.killCount / 10 + 1 && enemiesOnScreen < 100:
		var goblbin = Goblbin.instance()
		get_parent().call_deferred("add_child", goblbin)
		var goblbinPos = Vector2(rand_range(topLeft.global_position.x, bottomRight.global_position.x), 
				rand_range(topLeft.global_position.y, bottomRight.global_position.y))
		goblbin.set_deferred("global_position", goblbinPos)
		canSpawn -= 1
		enemiesOnScreen += 1
	elif $Timer.is_stopped():
		$Timer.start(rand_range(cooldownRange[0], cooldownRange[1]))

func removeGoblbin(_kills):
	enemiesOnScreen -= 1

func _on_Timer_timeout():
	canSpawn = rand_range(canSpawnRange[0], canSpawnRange[1] * KillCount.killCount / 10 + 1)
	$Timer.stop()
