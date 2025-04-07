extends CharacterBody2D

const MAX_SPEED = 190.0
const INIT_SPEED = 10.0
const ACCEL = 800.0
const JUMP_VELOCITY = -275.0
const JUMP_TIME = 0.4
const JUMP_BUFFER = 0.15
const COYOTE_TIME = 0.15
const WALL_TIME = 0.25

var accept_input = true

var direction
var jump_timer = 0
var jump_buffer_timer = 0
var double_jump = true
var wall_timer = 0
var wall_jump_x = 0
var coyote_timer = 0
var slip = 0.0
var momentum = {"speed": 0, "dir": 0, "jump": false, "decel": 0}
var falling = false

@onready var RLO: RayCast2D = $RayLeftOuter
@onready var RLI: RayCast2D = $RayLeftInner
@onready var RRO: RayCast2D = $RayRightOuter
@onready var RRI: RayCast2D = $RayRightInner
@onready var RLW: RayCast2D = $RayLeftWall
@onready var RRW: RayCast2D = $RayRightWall
@onready var RLF: RayCast2D = $RayLeftFloor
@onready var RRF: RayCast2D = $RayRightFloor

@onready var sprite = $Sprite2D
@onready var animplayer = $AnimationPlayer
@onready var camera = $Camera2D

func zoom_camera(zoom):
  var tween = get_tree().create_tween()
  tween.tween_property(
    camera, "zoom", zoom, 1.5
    ).set_ease(
      Tween.EASE_IN
    ).set_trans(
      Tween.TRANS_SINE
    )
  
  
func _physics_process(delta: float) -> void:
  if not is_on_floor():
      if velocity.y < 0:
        velocity.y += get_gravity().y * delta
      else:
        if not (RLW.is_colliding() or RRW.is_colliding()):
          velocity.y += get_gravity().y * delta * 1.5
          falling = true
        else:
          velocity.y += get_gravity().y * delta * 0.4
  else:
    var current_floor
    if RLF.get_collider():
      current_floor = RLF.get_collider()
    elif RRF.get_collider():
      current_floor = RRF.get_collider()
      
    if current_floor:
      if current_floor.has_method("momentum"):
        momentum = current_floor.momentum()
      else:
        momentum = {"speed": 0, "dir": 0, "jump": false, "decel": 0}

  if accept_input:
    # Handle jump.
    if (RLW.is_colliding() or RRW.is_colliding()):
      wall_timer = WALL_TIME
    else:
      if wall_timer > 0:
        wall_timer -= delta
      
    if Input.is_action_just_pressed("Jump") and accept_input:
      jump_buffer_timer = JUMP_BUFFER
    elif jump_timer > 0:
      if Input.is_action_pressed("Jump") and accept_input:
        velocity.y += JUMP_VELOCITY / 25
        jump_timer -= delta
      else:
        jump_timer = 0
    
    if jump_buffer_timer > 0:
      if is_on_floor() or coyote_timer > 0:
        #snap around ledges
        if RLO.is_colliding() and !RLI.is_colliding() \
          and !RRI.is_colliding() and !RRO.is_colliding():
            position.x += 5
            slip = -15
        if RRO.is_colliding() and !RRI.is_colliding() \
          and !RLI.is_colliding() and !RLO.is_colliding():
            position.x -= 5
            slip = 15

        velocity.y = JUMP_VELOCITY
        jump_buffer_timer = 0
        jump_timer = JUMP_TIME

      elif wall_timer > 0:
        velocity.y = JUMP_VELOCITY * 0.8
        jump_timer = JUMP_TIME
        wall_jump_x = (
          (int(RLW.is_colliding()) * 1) \
          + (int(RRW.is_colliding()) * -1)
          ) * 150
        wall_timer = 0
        jump_buffer_timer = 0
        double_jump = true

      elif double_jump:
        velocity.y = JUMP_VELOCITY * 0.9
        jump_timer = JUMP_TIME * 0.5
        double_jump = false
        jump_buffer_timer = 0

      else:
        jump_buffer_timer -= delta
        
    # make movement more responsive by immediately changing horizontal velocity when an action is pressed
    if Input.is_action_just_pressed("Left") and accept_input:
      velocity.x = INIT_SPEED * -1
    elif Input.is_action_just_pressed("Right") and accept_input:
      velocity.x = INIT_SPEED
    # apply acceleration after first frame of horizontal input
    else:
        direction = Input.get_axis("Left", "Right")

        if direction:
          var added_speed = slip

          # check if momentum should be applied
          if momentum["speed"] > 0 and (
            direction/abs(direction)) == momentum["dir"] and \
          !momentum["jump"] or (momentum["jump"] and (jump_timer > 0)
          ):
            # apply momentum and lower it
            added_speed += momentum["speed"]
            momentum["speed"] -= momentum["decel"] * delta
          else:
            momentum = {
              "speed": 0, "dir": 0, "jump": false, "decel": 0
              }
            
          if jump_timer > 0:
            added_speed += MAX_SPEED * 0.5

          velocity.x = move_toward(
            velocity.x, (MAX_SPEED + added_speed) * direction,
            ACCEL * delta
          )
        else:
          velocity.x = move_toward(velocity.x, slip, ACCEL * delta)
    
    if wall_jump_x != 0:
      velocity.x = wall_jump_x
      wall_jump_x = 0
    
    if is_on_floor():
      if abs(slip) >= 5:
        slip += (slip / 5) * -1
      else:
        slip = 0
      coyote_timer = COYOTE_TIME
      double_jump = true
    else:
      if coyote_timer > 0:
        coyote_timer -= delta

  # animations
  if accept_input:
    direction = Input.get_axis("Left", "Right")
    if direction:
      animplayer.play("Run")
      sprite.flip_h = direction < 0
      
  if falling and is_on_floor():
    falling = false
    animplayer.play("Landing")

  if velocity.y < 0:
    animplayer.play("Jump up")

  if velocity.y > 0:
    animplayer.play("Jump down")
    
  if !animplayer.is_playing():
    animplayer.play("Idle")
    
  animplayer.advance(0)

  move_and_slide()
