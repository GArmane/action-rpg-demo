extends Area2D

export var show_hit_effect: bool = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit_effect:
		var effect = HitEffect.instance()
		var world = get_tree().current_scene
		
		world.add_child(effect)
		effect.global_position = global_position - Vector2(0, 8)
