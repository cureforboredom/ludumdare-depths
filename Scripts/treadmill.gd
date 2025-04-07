class_name Treadmill

extends StaticBody2D

@export var speed = 100
@export var dir = 1

func _ready() -> void:
  constant_linear_velocity = Vector2(speed * dir, 0)
  
func momentum() -> Dictionary:
  return {"speed": 100, "dir": dir, "jump": false, "decel": 100}