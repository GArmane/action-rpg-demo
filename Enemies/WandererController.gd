extends Node2D

export var wander_range: int = 32

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

# Engine Callbacks
func _ready():
	_update_target_position()

# Public functions
func get_time_left():
	return timer.time_left

func start_timer(duration: int):
	timer.start(duration)

# Private functions
func _update_target_position():
	var target_vector = Vector2(
		rand_range(-wander_range, wander_range),
		rand_range(-wander_range, wander_range)
	)
	target_position = start_position + target_vector

# Signals
func _on_Timer_timeout():
	_update_target_position()
