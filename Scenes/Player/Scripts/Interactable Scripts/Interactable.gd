extends Node2D
class_name Interactable

@export var interaction_radius: float = 48.0
@export var interaction_text: String = ""

var sprite: Sprite2D

func _init_interactable() -> void:
	sprite = $Sprite2D
	if sprite.material is ShaderMaterial:
		var mat = sprite.material as ShaderMaterial
		mat.set_shader_parameter("progress", 0.0)
	else:
		push_warning("Sprite material is not a ShaderMaterial!")

func can_interact(player: Node2D) -> bool:
	return position.distance_to(player.global_position) <= interaction_radius

func set_outline(enabled: bool) -> void:
	if sprite == null:
		return
	if sprite.material is ShaderMaterial:
		var mat = sprite.material as ShaderMaterial
		mat.set_shader_parameter("progress", 1.0 if enabled else 0.0)
	else:
		push_warning("Sprite material is not a ShaderMaterial!")

func interact() -> void:
	print("Interacted with: %s" % name)
