extends Resource

class_name SoundEvent


@export var name: String
@export var streams: Array[AudioStream] = []
@export_enum("SFX", "Music", "Ambience") var type := "SFX"
@export var volume_db = 0.0
@export var loop := false
@export var max_distance := 128
@export var attenuation := 1.5