extends Node

@export var camera: Camera2D
@export var camera_target: Node2D
@export var smoothing_speed := 8.0
@export var offset := Vector2.ZERO
@export var snap_threshold := 0.25  # Distance threshold to snap directly

func _physics_process(delta):
	if not camera or not camera_target:
		return

	var desired_position = camera_target.global_position + offset
	var distance = camera.global_position.distance_to(desired_position)

	if distance <= snap_threshold:
		# Snap directly when close to avoid jitter
		camera.global_position = desired_position.round()
	else:
		# Smoothly move toward the target
		camera.global_position = camera.global_position.lerp(desired_position, smoothing_speed * delta)
