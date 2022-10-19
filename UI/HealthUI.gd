extends Control

onready var heart_ui_empty = $HeartUIEmpty
onready var heart_ui_full = $HeartUIFull
onready var stats = PlayerStats

var hearts = 4 setget _set_hearts
var max_hearts = 4 setget _set_max_hearts

# Engine callbacks
func _ready():
	self.max_hearts = stats.max_health
	self.hearts = stats.health
	stats.connect("health_changed", self, "_set_hearts")
	stats.connect("max_health_changed", self, "_set_max_hearts")

# Private functions
func _set_hearts(value: int):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.rect_size.x = hearts * 15

func _set_max_hearts(value: int):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.rect_size.x = hearts * 15
