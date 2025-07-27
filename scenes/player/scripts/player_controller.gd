extends CharacterBody2D
class_name Player

@export_category("Movement Settings")
@export var movement_speed: float = 100.0
@export var sprinting_speed: float = 180.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

@export_category("Player References")
@export var state_machine: Node 
@export var interaction_manager: Node 
@export var footstep_controller: Node 
@export var camera_follow: Node

@export var interaction_prompt_panel: PanelContainer
@export var interaction_prompt_label: Label
@export var tilemap_layer: TileMapLayer
@export var camera: Camera2D

var is_sprinting: bool = false

func _ready():
	# Setup interaction manager
	if interaction_manager:
		interaction_manager.player = self
		interaction_manager.interaction_prompt_node = interaction_prompt_panel
		interaction_manager.interaction_prompt_label = interaction_prompt_label
		interaction_manager.init_prompt()
	
	# Setup footstep controller
	if footstep_controller:
		footstep_controller.player = self
		footstep_controller.tilemap_layer = tilemap_layer
		footstep_controller.init_tilemap()
	
	# Setup camera follow
	if camera_follow and camera:
		camera_follow.target = self
		camera_follow.camera = camera
