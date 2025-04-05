extends Node2D

@onready var player = $Player

@export var player_start = Vector2(110, 426)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass

func _on_hazard_reset():
  player.position = player_start