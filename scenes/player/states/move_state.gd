extends PlayerState

func enter():
	print("Entered Move State")
	player = state_machine.player
	
	if animation_player.current_animation != "PlayerWalk":
		animation_player.play("PlayerWalk")
	
func physics_update(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("input_right") - Input.get_action_strength("input_left"),
		Input.get_action_strength("input_down") - Input.get_action_strength("input_up")
	).normalized()

	player.is_sprinting = Input.is_action_pressed("input_sprint")

	var max_speed = player.sprinting_speed if player.is_sprinting else player.movement_speed

	var target_velocity = input_vector * max_speed

	if input_vector != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(target_velocity, player.acceleration * _delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.friction * _delta)

	player.move_and_slide()

	animation_player.speed_scale = 1.5 if player.is_sprinting else 1.0

	if input_vector == Vector2.ZERO:
		state_machine.transition_to("IdleState")
