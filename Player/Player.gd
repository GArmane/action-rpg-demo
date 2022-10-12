extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

var velocity = Vector2.ZERO

# Engine callbacks
func _physics_process(delta: float):
	_process_movement(delta)

# Private functions
func _process_movement(delta: float):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(
			input_vector * MAX_SPEED,
			ACCELERATION * delta
		)
	else:
		 velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
