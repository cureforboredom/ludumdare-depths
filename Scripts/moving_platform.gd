extends Node2D

class_name MovingPlatform

var tween

@onready var animbody = $AnimBody
@onready var collider = $AnimBody/Collider
@onready var poly = $AnimBody/Poly

func _ready() -> void:
  animbody.data = {"speed": 100, "dir": 1, "jump": true}
  poly.polygon = collider.polygon
  tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
  tween.set_loops()
  tween.tween_property($AnimBody, "position", Vector2(336.0, 0.0), 5.0).set_trans(Tween.TRANS_SINE)
  tween.tween_property($AnimBody, "position", Vector2(0.0, 0.0), 5.0).set_trans(Tween.TRANS_SINE)
  tween.connect("step_finished", self._on_step_finished)

func kill():
  tween.kill()

func _on_step_finished(index):
  animbody.data["dir"] = [-1, 1][index]
