extends Node2D

onready var animated_sprite = $AnimatedSprite

# Engine Callbacks
func _ready():
	animated_sprite.play()

# Signals
func _on_AnimatedSprite_animation_finished():
	queue_free()
