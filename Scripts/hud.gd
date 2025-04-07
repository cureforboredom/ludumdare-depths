extends CanvasLayer

signal reset

@onready var timer_label = $Timer
@onready var menu = $Menu

var medal_ui
var medal_placeholder

var run = false
var timer: float = 0.0

var medal = "none"

func _reset():
  reset.emit()

func _get_medal_ui(link):
  medal_ui = link

func _get_medal_placeholder(link):
  medal_placeholder = link  

func _ready() -> void:
  self.connect("reset", owner._reset)

func _process(delta: float) -> void:
  if run:
    timer += delta
    update_timer_label()

func start_timer():
  run = true

func stop_timer():
  run = false
  
func reset_timer():
  timer = 0
  update_timer_label()

func update_timer_label():
  var minutes = timer / 60.0
  var seconds = fmod(timer, 60.0)
  timer_label.text = "%02d:%05.2f" % [minutes, seconds]
  
func display(state):
  menu.visible = true

  match state:
    "none":
      menu.visible = false
    "win":
      if timer <= 28.0:
        medal = "Gold"
      elif timer <= 32.0 and medal != "Gold":
        medal = "Silver"
      elif timer <= 40.0 and medal == "none":
        medal = "Bronze"        
        
      if medal != "none":
        medal_ui.change(medal)
        medal_placeholder.visible = false
        medal_ui.visible = true
    "die":
      pass
    "play":
      pass
