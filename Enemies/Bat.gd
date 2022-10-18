extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const KNOCKBACK_SPEED = 120
const KNOCKBACK_FRICTION = 200

export var ACCELERATION: int = 300
export var FRICTION: int = 200
export var MAX_SPEED: int = 50

onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetection

var knockback = Vector2.ZERO
var state = CHASE
var velocity = Vector2.ZERO

# Engine callbacks
func _physics_process(delta: float):
	knockback = knockback.move_toward(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			_seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0

	velocity = move_and_slide(velocity)

# State machine
func _seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

# Signals
func _on_Hurtbox_area_entered(area: Area2D):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_SPEED

func _on_Stats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(death_effect)
	death_effect.position = position
	queue_free()
