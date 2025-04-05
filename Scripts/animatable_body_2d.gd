extends AnimatableBody2D

@onready var collider = $Collider
@onready var poly = $Poly

func _ready() -> void:
  poly.polygon = collider.polygon
  var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
  tween.set_loops().set_parallel(false)
  tween.tween_property(self, "position", Vector2(592.0, 384.0), 5.0).set_trans(Tween.TRANS_SINE)
  tween.tween_property(self, "position", Vector2(256.0, 384.0), 5.0).set_trans(Tween.TRANS_SINE)