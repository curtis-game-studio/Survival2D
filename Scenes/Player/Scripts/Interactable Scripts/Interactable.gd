extends Node2D
class_name Interactable

@export var interaction_radius := 48.0
@export var interaction_text := ""
var sprite: Sprite2D = null

func _ready() -> void:
	sprite = $Sprite2D
	if sprite.material is ShaderMaterial:
		var mat := sprite.material as ShaderMaterial
		mat.set_shader_parameter("progress", 0.0)
	else:
		print("Warning: Sprite material is not a ShaderMaterial!")

func can_interact(player: Node2D) -> bool:
	return position.distance_to(player.global_position) <= interaction_radius

func set_outline(enabled: bool) -> void:
	if sprite == null:
		return
	if sprite.material is ShaderMaterial:
		var mat := sprite.material as ShaderMaterial
		mat.set_shader_parameter("progress", 1.0 if enabled else 0.0)
	else:
		print("Warning: Sprite material is not a ShaderMaterial!")

func interact() -> void:
	print("Interacted with: ", name)
