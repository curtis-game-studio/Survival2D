extends Interactable

func _ready() -> void:
    _init_interactable()

func interact():
    print("Interacted with: " + name)
