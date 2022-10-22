extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const KNOCKBACK_SPEED = 120
const KNOCKBACK_FRICTION = 200
const SOFT_COLLISION_PUSHBACK = 400

export var ACCELERATION: int = 300
export var FRICTION: int = 200
export var MAX_SPEED: int = 50
export var WANDER_TARGET_RANGE = 4

onready var hurtbox = $Hurtbox
onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetection
onready var soft_collision = $SoftCollision
onready var wanderer_controller = $WandererController

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
			if wanderer_controller.get_time_left() == 0:
				_update_state()
		WANDER:
			_seek_player()
			if wanderer_controller.get_time_left() == 0:
				_update_state()

			_accelerate_towards_point(wanderer_controller.target_position, delta)
			if global_position.distance_to(wanderer_controller.target_position) <= WANDER_TARGET_RANGE:
				_update_state()
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				_accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * SOFT_COLLISION_PUSHBACK
	velocity = move_and_slide(velocity)

func _ready():
	state = _pick_random_state([IDLE, WANDER])

# State machine
func _accelerate_towards_point(point: Vector2, delta: float):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func _change_wander_state():
	if wanderer_controller.get_time_left() == 0:
		wanderer_controller.start_timer(rand_range(1, 3))
		return _pick_random_state([IDLE, WANDER])

func _pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _update_state():
	state = _pick_random_state([IDLE, WANDER])
	wanderer_controller.start_timer(rand_range(1, 3))

# Signals
func _on_Hurtbox_area_entered(area: Area2D):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	var death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(death_effect)
	death_effect.position = position
	queue_free()
