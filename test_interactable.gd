extends Interactable

@export var is_lit: bool = false
@export var max_fuel: float = 30.0  # seconds of fuel
var current_fuel: float = 0.0

func _ready():
    _init_interactable()
    if is_lit:
        current_fuel = max_fuel
        start_fire()
    else:
        current_fuel = 0.0
        interaction_text = "Light Campfire"

func _process(delta):
    if is_lit:
        current_fuel -= delta
        if current_fuel <= 0:
            extinguish_fire()

func interact():
    if is_lit:
        extinguish_fire()
    else:
        light_fire()

func light_fire():
    is_lit = true
    current_fuel = max_fuel
    print("Campfire lit!")
    start_fire()
    interaction_text = "Extinguish Campfire"

func extinguish_fire():
    is_lit = false
    current_fuel = 0
    print("Campfire extinguished!")
    stop_fire()
    interaction_text = "Light Campfire"

func start_fire():
    AudioManager2D.play_sound2D_loop_positional("ambience_campfire", global_position)

func stop_fire():
    AudioManager2D.stop_sound2D_loop_positional("ambience_campfire")
