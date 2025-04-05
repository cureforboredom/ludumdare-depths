extends Area2D

@export var speed = 50

func _ready() -> void:
  gravity = speed

func _on_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D:
    if body.velocity.y > speed:
      body.velocity.y = speed
