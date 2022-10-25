extends AudioStreamPlayer

# Engine Callbacks
func _ready():
	var _conn = connect("finished", self, "queue_free")
