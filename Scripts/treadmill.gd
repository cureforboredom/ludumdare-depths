class_name Treadmill

extends StaticBody2D

@export var speed = 60

func _ready() -> void:
  constant_linear_velocity = Vector2(speed, 0)
  
func momentum() -> Dictionary:
  return {"speed": 100, "dir": 1, "jump": false, "decel": 100}