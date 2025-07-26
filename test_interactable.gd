extends Interactable

@export var is_lit: bool = false


func interact():
    # Toggle the campfire state on interact
    is_lit = !is_lit
    if is_lit:
        print("Campfire lit!")
        AudioManager2D.play_sound2D_loop_positional("ambience_campfire", global_position)
        interaction_text = "Extinguish Campfire"
    else:
        print("Campfire extinguished!")
        AudioManager2D.stop_sound2D_loop_positional("ambience_campfire")
        interaction_text = "Light Campfire"

