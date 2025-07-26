extends Node

@export var tilemap_layer_path: NodePath
@export var default_event := "footstep_default"

@export var surface_footstep_map: Dictionary = {
	"grass": "footstep_grass",
	"rock": "footstep_rock",
	"dirt": "footstep_dirt",
	"sand": "footstep_sand"
}

var tilemap_layer: TileMapLayer = null

func _ready() -> void:
	tilemap_layer = get_node_or_null(tilemap_layer_path)
	if tilemap_layer == null:
		push_error("❌ TileMapLayer not found at path: " + str(tilemap_layer_path))

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
	var player = get_parent().get_parent()
	if not player or not player is Node2D:
		push_error("❌ FootstepController's parent is not a Node2D")
		return

	var position = player.global_position
	var surface = get_surface_type(position)
	var event_name: String = surface_footstep_map.get(surface, default_event)

	AudioManager2D.play_sound2D_positional(event_name, position)
