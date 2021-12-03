extends Area2D
## for detecting player within a certain range

var player = null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(_body):
	player = null
