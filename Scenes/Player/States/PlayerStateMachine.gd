extends Node 
class_name PlayerStateMachine

var states := {}
var current_state: PlayerState = null
@export var player: Player
@export var animation_player: AnimationPlayer

func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name] = child
			child.state_machine = self

	if states.has("IdleState"):
		transition_to("IdleState")

func transition_to(state_name: String):
	if !states.has(state_name):
		push_error("State '%s' not found!" % state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.player = player
	current_state.animation_player = animation_player

	
	current_state.enter()

func _physics_process(_delta):
	if current_state:
		current_state.physics_update(_delta)
