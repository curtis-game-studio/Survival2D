extends Node
class_name AudioRegistry

@export var sound_events: Array[SoundEvent] = []

var sound_map: Dictionary = {}

func _ready() -> void:
	for event in sound_events:
		sound_map[event.name] = event

func get_event(event_name: String) -> SoundEvent:
	return sound_map.get(event_name, null)
