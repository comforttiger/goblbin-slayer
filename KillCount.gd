extends Node2D
## global thing for counting the killcount

var killCount = 0
signal added_kill(kills)


## function for adding a kill to the killcount, called by goblbins when they die
func addKill():
	killCount += 1
	emit_signal("added_kill", killCount)


## function for reloading the killcount, for use when restarting the game
func reload():
	killCount = 0
