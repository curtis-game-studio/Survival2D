extends Node

@export var head_node_path: NodePath = "../Visuals/Head"
@export var bob_speed: float = 1.0  # Bobs per second
@export var bob_amount: float = 1.0  # Pixels to move up/down

var head_node: Node2D
var base_position: Vector2 = Vector2.ZERO
var bob_timer: float = 0.0

func _ready() -> void:
	head_node = get_node(head_node_path)
	base_position = head_node.position

func _process(delta: float) -> void:
	bob_timer += delta * bob_speed
	var phase = fmod(bob_timer, 1.0)
	var offset_y = bob_amount if phase < 0.5 else 0
	head_node.position = base_position + Vector2(0, offset_y)
