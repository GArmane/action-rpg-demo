extends KinematicBody2D

const player_hut_sound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var FRICTION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var ROLL_VELOCITY_RESISTENCE = 0.5

enum {
	ATTACK,
	MOVE,
	ROLL,
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var blink_animation = $BlinkAnimation
onready var hurtbox = $Hurtbox
onready var sword_hitbox = $HitboxPivot/SwordHitbox

# Engine callbacks
func _physics_process(delta:float):
	match state:
		MOVE:
			_process_move_state(delta)
		ATTACK:
			_process_attack_state(delta)
		ROLL:
			_process_roll_state(delta)

func _ready():
	animation_tree.active = true
	stats.connect("no_health", self, "queue_free")
	sword_hitbox.knockback_vector = roll_vector

# State Machine
func _attack_state_finished():
	state = MOVE

func _roll_state_finished():
	velocity = velocity * ROLL_VELOCITY_RESISTENCE
	state = MOVE

func _process_attack_state(_delta: float):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func _process_move_state(delta: float):
	var input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	if input_vector != Vector2.ZERO:
		_set_blend_positions(input_vector)
		animation_state.travel("Run")

		_update_roll_vector(input_vector)
		velocity = velocity.move_toward(
			input_vector * MAX_SPEED,
			ACCELERATION * delta
		)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	_move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	

func _process_roll_state(_delta: float):
	animation_state.travel("Roll")

	velocity = roll_vector * ROLL_SPEED
	_move()

# Private Functions
func _move():
	velocity = move_and_slide(velocity)

func _set_blend_positions(vector: Vector2):
	animation_tree.set("parameters/Attack/blend_position", vector)
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Roll/blend_position", vector)
	animation_tree.set("parameters/Run/blend_position", vector)

func _update_roll_vector(vector: Vector2):
	roll_vector = vector
	sword_hitbox.knockback_vector = vector

# Signals
func _on_Hurtbox_area_entered(area: Area2D):
	stats.health -= area.damage
	hurtbox.start_invinsibility(0.5)
	hurtbox.create_hit_effect()

	get_tree().current_scene.add_child(player_hut_sound.instance())

func _on_Hurtbox_invincibility_ended():
	blink_animation.play("Stop")

func _on_Hurtbox_invincibility_started():
	blink_animation.play("Start")
