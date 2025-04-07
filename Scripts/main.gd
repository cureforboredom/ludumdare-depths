extends Node2D

var player_instance = null
var timer_started = false
var input_timer
var paused = true
var platforms

@onready var hud: CanvasLayer = $Hud
@onready var player = preload("res://Scenes/player.tscn")

@export var level : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  hud.display("play")
  
func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("Reset"):
    reset()
  if Input.is_action_just_pressed("Pause"):
    pause()
  if player_instance:
    if !paused:
      player_instance.paused = false
      if !input_timer.time_left:
        player_instance.accept_input = true
        if !timer_started and (
          Input.is_action_pressed("Jump") or 
          Input.is_action_pressed("Left") or 
          Input.is_action_pressed("Right")
        ):
          hud.start_timer()
          timer_started = true
    else:
      player_instance.paused = true

func _platforms(node):
  platforms = node
  
func _start_platforms(body):
  if body is CharacterBody2D:
    platforms.start()
    platforms.remove_trigger()

func _on_hazard_reset():
  die()
  
func _on_level_exit_win():
  win()
  
func _reset():
  reset()
  
func _camera_change(body, zoom):
  if body is CharacterBody2D:
    player_instance.zoom_camera(zoom)
  
func reset():
  paused = false
  input_timer = get_tree().create_timer(0.55)
  if player_instance:
    player_instance.queue_free()
  player_instance = player.instantiate()
  self.call_deferred("add_child", player_instance)
  player_instance.set_deferred("position", level.get_meta("start"))
  player_instance.set_deferred("accept_input", false)
  
  platforms.reset()

  hud.display("none")
  hud.stop_timer()
  hud.reset_timer()
  timer_started = false
  
func win():
  paused = true
  hud.stop_timer()
  hud.display("win")
  player_instance.accept_input = false

func die():
  paused = true
  hud.stop_timer()
  hud.display("die")
  player_instance.accept_input = false
  
func pause():
  paused = true
  hud.stop_timer()
  hud.reset_timer()
  hud.display("play")
  player_instance.accept_input = false