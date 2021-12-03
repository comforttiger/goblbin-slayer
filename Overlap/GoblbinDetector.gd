extends Area2D

## function for seeing if we're colliding with anything
func is_colliding():
	return get_overlapping_areas().size() > 0


## function that returns the vector for moving away from goblbins that are overlapping
func get_push_vector():
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = get_overlapping_areas()[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector
