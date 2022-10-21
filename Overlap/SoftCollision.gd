extends Area2D

func is_colliding() -> bool:
	return get_overlapping_areas().size() > 0

func get_push_vector() -> Vector2:
	if is_colliding():
		var area = get_overlapping_areas()[0]
		return area.global_position.direction_to(global_position).normalized()
	else:
		return Vector2.ZERO
