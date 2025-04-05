extends Node2D

var platforms = []

@onready var platform = preload("res://Scenes/moving_platform.tscn")

func _ready() -> void:
  for node in get_children():
    platforms.append([node.transform, node.dist, node.duration])

func reset():
  for node in get_children():
    node.kill()
    node.queue_free()
  for node in platforms:
    var platform_instance = platform.instantiate()
    add_child(platform_instance)
    platform_instance.transform = node[0]
    platform_instance.dist = node[1]
    platform_instance.duration = node[2]
    platform_instance.setup()
