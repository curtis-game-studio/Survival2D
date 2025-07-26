extends Node

@export var camera: Camera2D
@export var camera_target: Node2D
@export var smoothing_speed: float = 8.0
@export var offset: Vector2 = Vector2.ZERO
@export var snap_threshold: float = 0.25

func _physics_process(delta: float) -> void:
	if not camera or not camera_target:
		return

	var desired_position = camera_target.global_position + offset
	var distance = camera.global_position.distance_to(desired_position)

	if distance <= snap_threshold:
		camera.global_position = desired_position.round()
	else:
		camera.global_position = camera.global_position.lerp(desired_position, smoothing_speed * delta)
