extends Node  # Or whatever your Scripts node extends

@export var head_node_path: NodePath = "../Visuals/Head"  # Relative path to Head node

@export var bob_speed := 1.0  # Bobs per second
@export var bob_amount := 1   # Pixels to move down/up

var head_node: Node2D
var base_position := Vector2.ZERO
var bob_timer := 0.0

func _ready():
    head_node = get_node(head_node_path)
    base_position = head_node.position

func _process(delta):
    bob_timer += delta * bob_speed
    var phase = fmod(bob_timer, 1.0)
    var offset_y = bob_amount if phase < 0.5 else 0
    head_node.position = base_position + Vector2(0, offset_y)
