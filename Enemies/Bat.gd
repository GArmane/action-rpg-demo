extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const KNOCKBACK_SPEED = 120
const KNOCKBACK_FRICTION = 200

var knockback = Vector2.ZERO

onready var stats = $Stats

# Engine callbacks
func _physics_process(delta: float):
	knockback = knockback.move_toward(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)

# Signals
func _on_Hurtbox_area_entered(area: Area2D):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_SPEED

func _on_Stats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(death_effect)
	death_effect.position = position
	queue_free()
