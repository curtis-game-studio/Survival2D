extends Node
class_name FootstepController

@export var player: Node2D
@export var tilemap_layer: TileMapLayer = null
@export var default_event := "footstep_default"

@export var surface_footstep_map: Dictionary = {
	"grass": "footstep_grass",
	"rock": "footstep_rock",
	"dirt": "footstep_dirt",
	"sand": "footstep_sand"
}

func init_tilemap():
	if tilemap_layer == null:
		push_error("❌ FootstepController is missing a TileMapLayer reference.")

func get_surface_type(world_position: Vector2) -> String:
	if tilemap_layer == null:
		return ""

	var local_pos = tilemap_layer.to_local(world_position)
	var coords = tilemap_layer.local_to_map(local_pos)

	var tile_data := tilemap_layer.get_cell_tile_data(coords)
	if tile_data and tile_data.has_custom_data("surface_type"):
		return tile_data.get_custom_data("surface_type")

	return ""

func play_footstep() -> void:
	if player == null:
		push_error("❌ FootstepController has no player reference")
		return

	var position = player.global_position
	var surface = get_surface_type(position)
	var event_name: String = surface_footstep_map.get(surface, default_event)

	AudioManager2D.play_sound2D_positional(event_name, position)
