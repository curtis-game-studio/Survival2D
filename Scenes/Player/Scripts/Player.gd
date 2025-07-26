extends CharacterBody2D
class_name Player

@export var movement_speed: float = 100.0
@export var sprinting_speed: float = 180.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

var is_sprinting: bool = false
