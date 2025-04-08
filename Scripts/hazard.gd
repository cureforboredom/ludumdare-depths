extends Area2D

signal reset

@onready var particles = $Particles

@export var emit = true

func _ready() -> void:
  self.connect("reset", owner._on_hazard_reset)
  particles.emitting = emit 
  var amount = clamp(360 * (abs(scale.x) / 2), 1, 1024)
  particles.amount = amount
  if abs(scale.y) < 1.0:
    particles.lifetime = 3.0
    particles.amount *= 0.5
func _on_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D:
    reset.emit()
