extends Node
class_name CameraFollow

@export var camera: Camera2D
@export var target: CharacterBody2D
@export var smoothing_speed: float = 8.0
@export var offset: Vector2 = Vector2.ZERO
@export var snap_threshold: float = 0.25

func _physics_process(delta: float) -> void:
	if not camera or not target:
		return

	var desired_position = target.global_position + offset
	var distance = camera.global_position.distance_to(desired_position)

	if distance <= snap_threshold:
		camera.global_position = desired_position.round()
	else:
		camera.global_position = camera.global_position.lerp(desired_position, smoothing_speed * delta)
