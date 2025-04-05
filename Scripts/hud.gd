extends CanvasLayer

var run = false
var timer: float = 0.0

func _process(delta: float) -> void:
  if run:
    timer += delta
    update_label()

func start_timer():
  run = true

func stop_timer():
  run = false
  
func reset_timer():
  timer = 0
  update_label()

func update_label():
  var minutes = timer / 60.0
  var seconds = fmod(timer, 60.0)
  $Timer.text = "%02d:%05.2f" % [minutes, seconds]