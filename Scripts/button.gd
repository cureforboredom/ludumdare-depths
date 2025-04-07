extends Button

func _ready() -> void:
  self.connect("pressed", owner._reset)
