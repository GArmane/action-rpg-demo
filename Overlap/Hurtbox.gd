extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible: bool = false setget _set_invincible

signal invincibility_started
signal invincibility_ended

# Public functions
func create_hit_effect():
	var effect = HitEffect.instance()
	var world = get_tree().current_scene
	
	world.add_child(effect)
	effect.global_position = global_position - Vector2(0, 8)

func start_invinsibility(duration: float):
	self.invincible = true
	timer.start(duration)

# Private functions
func _set_invincible(value: bool):
	invincible = value
	match invincible:
		true:
			emit_signal("invincibility_started")
		false:
			emit_signal("invincibility_ended")

# Signals
func _on_Hurtbox_invincibility_ended():
	set_deferred("monitoring", true)

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)

func _on_Timer_timeout():
	self.invincible = false
