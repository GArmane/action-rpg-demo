extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

enum {
	ATTACK,
	MOVE,
	ROLL,
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

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

# State Machine
func _attack_state_finished():
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
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")

		velocity = velocity.move_toward(
			input_vector * MAX_SPEED,
			ACCELERATION * delta
		)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func _process_roll_state(_delta: float):
	pass
