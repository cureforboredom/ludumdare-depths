extends Label


signal link

func _ready() -> void:
  self.connect("link", owner._get_medal_placeholder.bind(self))
  link.emit()