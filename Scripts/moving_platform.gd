extends Node2D

class_name MovingPlatform

var tween

@onready var animbody = $AnimBody
@onready var collider = $AnimBody/Collider
@onready var poly = $AnimBody/Poly

@export var dist : Vector2 = Vector2(100, 0)
@export var duration : float = 5.0

func _ready() -> void:
  poly.polygon = collider.polygon
  
func setup():
  var speed = dist.x / duration
  animbody.data = {"speed": speed, "dir": 1, "jump": true, "decel": 5}
  tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
  tween.set_loops()
  tween.tween_property($AnimBody, "position", dist, duration).set_trans(Tween.TRANS_SINE)
  tween.tween_property($AnimBody, "position", Vector2(0.0, 0.0), duration).set_trans(Tween.TRANS_SINE)
  tween.connect("step_finished", self._on_step_finished)

func kill():
  if tween:
    tween.kill()

func _on_step_finished(index):
  animbody.data["dir"] = [-1, 1][index]
