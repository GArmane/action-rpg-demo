extends KinematicBody2D

const ACCELERATION = 25
const FRICTION = 400
const MAX_SPEED = 200

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
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		 velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_collide(velocity)
