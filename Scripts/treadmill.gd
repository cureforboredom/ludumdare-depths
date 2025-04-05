extends StaticBody2D

@export var speed = 50

func _ready() -> void:
  constant_linear_velocity = Vector2(speed, 0)