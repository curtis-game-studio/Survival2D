extends Resource
class_name SoundEvent

@export var name: String
@export var streams: Array[AudioStream] = []
@export_enum("SFX", "Music", "Ambience") var type := "SFX"
@export var volume_db: float = 0.0
@export var loop: bool = false
@export var max_distance: float = 128.0
@export var attenuation: float = 1.5
