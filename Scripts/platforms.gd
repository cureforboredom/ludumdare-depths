extends Node2D

signal send_to_main

var platforms = []
var delayed = []

@onready var platform = preload("res://Scenes/moving_platform.tscn")
@onready var area = $Area2D

func _ready() -> void:
  self.connect("send_to_main", owner._platforms)
  area.connect("body_entered", owner._start_platforms)
  for node in get_children():
    if node is MovingPlatform:
      platforms.append(
        [node.position, node.dist, node.duration, node.use_trigger]
      )
    
  send_to_main.emit(self)

func reset():
  area.set_deferred("monitoring", true)
  delayed = []
  for node in get_children():
    if node is MovingPlatform:
      node.kill()
      node.queue_free()
  for node in platforms:
    var platform_instance = platform.instantiate()
    self.call_deferred("add_child", platform_instance)
    platform_instance.call_deferred("move", node)
    if !node[3]:
      platform_instance.call_deferred("setup")
    else:
      delayed.append(platform_instance)

func start():
  for node in delayed:
    node.call_deferred("setup")
    
func remove_trigger():
  area.set_deferred("monitoring", false)
