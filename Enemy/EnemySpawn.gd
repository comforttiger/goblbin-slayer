extends Node2D

export var canSpawnRange = [0, 5]
export var cooldownRange = [0, 30]
export var maxEnemies = 5
const Goblbin = preload("res://Enemy/Goblbin.tscn")
var can_spawn = 0
var pause = false
var wave_threshold = 2
var wave_nr = 0

onready var topLeft = $TopLeft
onready var bottomRight = $BottomRight
var enemies_on_screen = 0
var enemies_spawned = 0

func _ready():
	randomize()
# warning-ignore:return_value_discarded
	KillCount.connect("added_kill", self, "removeGoblbin")
	$Timer.start(1)

func _process(_delta):
	if !pause:
		spawn_goblbin()
	

func spawn_goblbin():
	if can_spawn > 0 && enemies_on_screen <= maxEnemies * KillCount.killCount / 10 + 1:
		var goblbin = Goblbin.instance()
		get_parent().call_deferred("add_child", goblbin)
		var goblbin_pos = Vector2(rand_range(topLeft.global_position.x, bottomRight.global_position.x), 
				rand_range(topLeft.global_position.y, bottomRight.global_position.y))
		goblbin.set_deferred("global_position", goblbin_pos)
		can_spawn -= 1
		enemies_on_screen += 1
		enemies_spawned += 1
	elif $Timer.is_stopped():
		$Timer.start(rand_range(cooldownRange[0], cooldownRange[1]))

func removeGoblbin(_kills):
	enemies_on_screen -= 1

func _on_Timer_timeout():
	can_spawn = rand_range(canSpawnRange[0], canSpawnRange[1] * KillCount.killCount / 10 + 1)
	$Timer.stop()
