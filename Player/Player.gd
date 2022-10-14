extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer

# Engine callbacks
func _physics_process(delta: float):
	_process_movement(delta)

# Private functions
func _process_animation(input_vector):
	if input_vector.x > 0:
		animation_player.play("RunRight")
	else:
		animation_player.play("IdleRight")

func _process_movement(delta: float):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	if input_vector != Vector2.ZERO:
		animation_player.play("RunRight")
		velocity = velocity.move_toward(
			input_vector * MAX_SPEED,
			ACCELERATION * delta
		)
	else:
		animation_player.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	_process_animation(input_vector)
	velocity = move_and_slide(velocity)
