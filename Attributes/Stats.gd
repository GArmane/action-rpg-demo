extends Node

export var max_health: int = 1 setget _set_max_health

var health = max_health setget _set_health

signal health_changed(value)
signal max_health_changed(value)
signal no_health

# Engine callbacks
func _ready():
	self.health = max_health

# Private functions
func _set_health(value: int):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _set_max_health(value: int):
	max_health = value
	self.health  = min(health, max_health)
	emit_signal("max_health_changed", max_health)
