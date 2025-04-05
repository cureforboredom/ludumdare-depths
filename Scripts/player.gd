extends CharacterBody2D

const MAX_SPEED = 190.0
const INIT_SPEED = 50.0
const ACCEL = 800.0
const JUMP_VELOCITY = -275.0
const JUMP_TIME = 0.4
const JUMP_BUFFER = 0.15
const COYOTE_TIME = 0.15
const WALL_TIME = 0.25

var jump_timer = 0
var jump_buffer_timer = 0
var double_jump = true
var wall_timer = 0
var wall_jump_x = 0
var coyote_timer = 0
var slip = 0.0

@onready var RLO: RayCast2D = $RayLeftOuter
@onready var RLI: RayCast2D = $RayLeftInner
@onready var RRO: RayCast2D = $RayRightOuter
@onready var RRI: RayCast2D = $RayRightInner
@onready var RLW: RayCast2D = $RayLeftWall
@onready var RRW: RayCast2D = $RayRightWall

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
      if velocity.y < 0:
        velocity += get_gravity() * delta
      else:
        if not (RLW.is_colliding() or RRW.is_colliding()):
          velocity += get_gravity() * delta * 2
        else:
          velocity = get_gravity() * delta * 2.5
      

  # Handle jump.
  if (RLW.is_colliding() or RRW.is_colliding()):
    wall_timer = WALL_TIME
  else:
    if wall_timer > 0:
      wall_timer -= delta
    
  if Input.is_action_just_pressed("Jump"):
    jump_buffer_timer = JUMP_BUFFER
  elif jump_timer > 0:
    if Input.is_action_pressed("Jump"):
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
      

  if Input.is_action_just_pressed("Left"):
    velocity.x = INIT_SPEED * -1
  elif Input.is_action_just_pressed("Right"):
    velocity.x = INIT_SPEED
  else:
    var direction = Input.get_axis("Left", "Right")
    if wall_jump_x != 0:
      direction += wall_jump_x / abs(wall_jump_x) / 2
      wall_jump_x -= delta * direction * 10
    if direction:
      velocity.x = move_toward(
        velocity.x, MAX_SPEED * direction \
        + slip, ACCEL * delta
        )
    else:
      velocity.x = move_toward(velocity.x, 0 + slip, ACCEL * delta)
  
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

  move_and_slide()
