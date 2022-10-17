extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func _create_grass_effect():
	var grass_effect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position

# Signals
func _on_Hurtbox_area_entered(_area: Area2D):
	_create_grass_effect()
	queue_free()
