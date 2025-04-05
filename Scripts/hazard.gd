extends Area2D

signal reset

func _on_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D:
    reset.emit()
