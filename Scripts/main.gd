extends Node2D

var player_instance = null
var platform_instance = null
var timer_started = false

@onready var hud: CanvasLayer = $Hud
@onready var platform = preload("res://Scenes/moving_platform.tscn")
@onready var player = preload("res://Scenes/player.tscn")

@export var player_start = Vector2(110, 426)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  reset()

func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("Reset"):
    reset()
  if !timer_started and (
    Input.is_action_pressed("Jump") or 
    Input.is_action_pressed("Left") or 
    Input.is_action_pressed("Right")
  ):
    hud.start_timer()
    timer_started = true

func _on_hazard_reset():
  reset()
  
func _on_level_exit_win():
  win()
  
func reset():
  if player_instance:
    player_instance.queue_free()
  player_instance = player.instantiate()
  add_child(player_instance)
  player_instance.position = player_start

  if platform_instance:
    platform_instance.kill()
    platform_instance.queue_free()
  platform_instance = platform.instantiate()
  add_child(platform_instance)
  platform_instance.position = Vector2(256, 384)

  hud.stop_timer()
  hud.reset_timer()
  timer_started = false
  
func win():
  hud.stop_timer()
