extends StaticBody2D

@onready var collider = $Collider
@onready var poly = $Poly

func _ready() -> void:
  poly.polygon = collider.polygon
