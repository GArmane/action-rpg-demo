extends Node2D

func _create_grass_effect():
	var grass_effect_scene = load("res://Effects/GrassEffect.tscn")
	var grass_effect = grass_effect_scene.instance()
	var world = get_tree().current_scene

	world.add_child(grass_effect)
	grass_effect.global_position = global_position

# Signals
func _on_Hurtbox_area_entered(_area: Area2D):
	_create_grass_effect()
	queue_free()
