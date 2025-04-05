extends Node2D

class_name MovingPlatform

var tween

@onready var collider = $AnimBody/Collider
@onready var poly = $AnimBody/Poly

func _ready() -> void:
  poly.polygon = collider.polygon
  tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
  tween.set_loops().set_parallel(false)
  tween.tween_property($AnimBody, "position", Vector2(336.0, 0.0), 5.0).set_trans(Tween.TRANS_SINE)
  tween.tween_property($AnimBody, "position", Vector2(0.0, 0.0), 5.0).set_trans(Tween.TRANS_SINE)

func kill():
  tween.kill()
