extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
signal invincibility_started
signal invincibility_ended
onready var timer = $Timer
var invincible = false


func _on_Hurtbox_area_entered(_area):
	# spawns a hit effect when ur hit
	var hitEffect = HitEffect.instance() 
	get_tree().current_scene.add_child(hitEffect)
	hitEffect.global_position = global_position
	invincibility_start(0.8) # starts invincibility

func invincibility_start(value):
	emit_signal("invincibility_started") # tells the owner of the hurtbox that theyre invincible
	invincible = true
	timer.start(value)


func _on_Timer_timeout():
	emit_signal("invincibility_ended") # tells the owner of the hurtbox that theyre not invincible anymore
	invincible = false
