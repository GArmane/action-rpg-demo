extends AnimatedSprite

# Engine Callbacks
func _ready():
	var _error = connect("animation_finished", self, "_on_animation_finished")
	play()

# Signals
func _on_animation_finished():
	queue_free()
