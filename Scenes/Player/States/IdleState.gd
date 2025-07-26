extends PlayerState

func enter():
	print("Entered Idle State")
	player = state_machine.player

	if animation_player.current_animation != "PlayerIdle":
		animation_player.play("PlayerIdle")

func physics_update(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("input_right") - Input.get_action_strength("input_left"),
		Input.get_action_strength("input_down") - Input.get_action_strength("input_up")
	).normalized()

	if input_vector != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(input_vector * player.movement_speed, player.acceleration * _delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.friction * _delta)

	player.move_and_slide()

	if player.velocity.length() > 1:
		state_machine.transition_to("MoveState")
