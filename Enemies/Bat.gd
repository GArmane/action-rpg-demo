extends KinematicBody2D

const KNOCKBACK_SPEED = 120
const KNOCKBACK_FRICTION = 200

var knockback = Vector2.ZERO

# Engine callbacks
func _physics_process(delta: float):
	knockback = knockback.move_toward(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)

# Signals
func _on_Hurtbox_area_entered(area: Area2D):
	knockback = area.knockback_vector * KNOCKBACK_SPEED
