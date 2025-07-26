extends Node
class_name InteractionManager

@export var player: Node2D
@export var max_interaction_distance := 64.0
@export var interaction_prompt_node: PanelContainer
@export var interaction_prompt_label: Label

var hovered: Interactable = null

func _ready() -> void:
	if interaction_prompt_node:
		interaction_prompt_node.visible = false
		interaction_prompt_label.visible = false

func _process(_delta: float) -> void:
	if player == null:
		print("Player not set.")
		return

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var world_pos: Vector2 = player.get_global_mouse_position()
	var space_state: PhysicsDirectSpaceState2D = player.get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var results: Array = space_state.intersect_point(query)

# Before processing results, clear old hovered highlight and hide prompt
	if hovered:
		hovered.set_outline(false)
		hovered = null
		if interaction_prompt_label and interaction_prompt_node:
			interaction_prompt_node.visible = false
			interaction_prompt_label.visible = false

	# Now find new hovered
	for hit in results:
		var collider: Node2D = hit.get("collider") as Node2D
		if collider and collider.has_method("interact"):
			var distance: float = player.global_position.distance_to(collider.global_position)
			if distance <= max_interaction_distance:
				hovered = collider
				hovered.set_outline(true)
				if interaction_prompt_label and interaction_prompt_node:
					interaction_prompt_label.text = "[E] " + hovered.interaction_text
					interaction_prompt_node.visible = true
					interaction_prompt_label.visible = true
					interaction_prompt_node.position = hovered.global_position + Vector2(0, -30)
				print("Hovering over:", collider.name)
				break

	for hit in results:
		var collider: Node2D = hit.get("collider") as Node2D
		if collider and collider.has_method("interact"):
			var distance: float = player.global_position.distance_to(collider.global_position)
			if distance <= max_interaction_distance:
				hovered = collider
				hovered.set_outline(true)
				print("Hovering over:", collider.name)
				break

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("input_interact") and hovered:
		print("Interacting with:", hovered.name)
		hovered.interact()
