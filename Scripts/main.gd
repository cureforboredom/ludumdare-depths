extends Node2D

var player_instance = null
var timer_started = false
var input_timer

@onready var hud: CanvasLayer = $Hud
@onready var player = preload("res://Scenes/player.tscn")
@onready var platforms = $Platforms

####### CHANGE ME
@export var level : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  reset()
  
func _process(_delta: float) -> void:
  if Input.is_action_just_pressed("Reset"):
    reset()
  if !input_timer.time_left:
    if player_instance:
      player_instance.accept_input = true
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
  input_timer = get_tree().create_timer(0.55)
  if player_instance:
    player_instance.queue_free()
  player_instance = player.instantiate()
  self.call_deferred("add_child", player_instance)
  player_instance.set_deferred("position", level.get_meta("start"))
  player_instance.set_deferred("accept_input", false)
  
  platforms.reset()

  hud.stop_timer()
  hud.reset_timer()
  timer_started = false
  
func win():
  hud.stop_timer()
