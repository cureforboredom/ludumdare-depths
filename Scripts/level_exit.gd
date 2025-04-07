extends Area2D

signal win

func _ready() -> void:
  self.connect("win", owner._on_level_exit_win)

func _on_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D:
    win.emit()
