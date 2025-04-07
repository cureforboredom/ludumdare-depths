extends AnimatedSprite2D

signal link

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.connect("link", owner._get_medal_ui.bind(self))
  link.emit()
  
func change(medal):
  label.text = medal
  frame = ["Bronze", "Silver", "Gold"].find(medal)