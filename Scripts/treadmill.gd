class_name Treadmill

extends StaticBody2D

@export var speed = 75

func _ready() -> void:
  constant_linear_velocity = Vector2(speed, 0)
  
func momentum() -> Dictionary:
  return {"speed": 125, "dir": 1, "jump": false, "decel": 100}