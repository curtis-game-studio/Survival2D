extends Node

@export var player_visuals: Node2D  # The Node2D that holds all your sprites

func _process(_delta):
    if not player_visuals:
        return
    
    var mouse_pos = player_visuals.get_global_mouse_position()
    var player_pos = player_visuals.global_position

    # Flip by changing scale.x
    player_visuals.scale.x = -1 if mouse_pos.x < player_pos.x else 1
