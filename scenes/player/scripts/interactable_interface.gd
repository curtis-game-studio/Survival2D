extends Node2D
class_name Interactable

@export var interaction_radius: float = 48.0
@export var interaction_text: String = ""
@export var outline_sprites: Array[NodePath] = []  # ✅ Assign these in the editor

var sprites: Array[Sprite2D] = []

func _ready() -> void:
	_init_interactable()

func _init_interactable() -> void:
	sprites.clear()

	for path in outline_sprites:
		var sprite = get_node_or_null(path)
		if sprite and sprite is Sprite2D:
			sprites.append(sprite)
		else:
			push_warning("Invalid or missing Sprite2D at path: %s" % str(path))

	# Optional: reset outline
	for sprite in sprites:
		if sprite.material is ShaderMaterial:
			var mat := sprite.material as ShaderMaterial
			mat.set_shader_parameter("progress", 0.0)

func can_interact(player: Node2D) -> bool:
	return position.distance_to(player.global_position) <= interaction_radius

func set_outline(enabled: bool) -> void:
	for sprite in sprites:
		if sprite.material is ShaderMaterial:
			var mat := sprite.material as ShaderMaterial
			mat.set_shader_parameter("progress", 1.0 if enabled else 0.0)
		else:
			push_warning("Sprite '%s' has no ShaderMaterial" % sprite.name)

func interact() -> void:
	print("✅ Interacted with: %s" % name)
