extends Node2D

@onready var area = $Area2D

@export var zoom : Vector2 = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.visible = false
  area.connect("body_entered", owner._camera_change.bind(zoom))
