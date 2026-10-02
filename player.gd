extends CharacterBody2D


enum State { IDLE, RUN, AIR, WALL }

@export var speed: float = 300.0
@export var jump_vel: float = -480.0
@export var gravity: float = 1400

const TEXTURES := {
	State.IDLE: preload("res://assets/player-idle.png"),
	State.RUN: preload("res://assets/player-run.png"),
	State.AIR: preload("res://assets/player-jump.png"),
	State.WALL: preload("res://assets/player-jump.png")
}

var state: State = State.IDLE

var spawn_point: Vector2

func _ready():
	spawn_point = position
	
func respawn() -> void:
	position = spawn_point
	velocity = Vector2.ZERO
	_change_state(State.AIR)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	if direction != 0.0:
		$Sprite2D.flip_h = direction < 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	match state:
		State.IDLE:
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel
			if is_on_wall() and not is_on_floor():
				_change_state(State.WALL)
			elif not is_on_floor():
				_change_state(State.AIR)
			elif direction != 0.0:
				_change_state(State.RUN)
		State.RUN:
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel
			if not is_on_floor():
				_change_state(State.AIR)
			elif direction == 0.0:
				_change_state(State.IDLE)
		State.AIR:
			if is_on_floor():
				_change_state(State.IDLE if direction == 0.0 else State.RUN)
			elif is_on_wall():
				_change_state(State.WALL)
		State.WALL:
			velocity.y += gravity * delta
			if Input.is_action_just_pressed("jump"):
				if position.x < 500:
					direction = -1.0
				else:
					direction = 1.0
				velocity.y = jump_vel
				_change_state(State.AIR)
			if is_on_floor():
				_change_state(State.IDLE if direction == 0.0 else State.RUN)
			elif not is_on_wall():
				_change_state(State.AIR)
		
	move_and_slide()
	
	if position.y > get_viewport_rect().size.y + 100.0:
		respawn()

func _change_state(new_state: State):
	state = new_state
	$Sprite2D.texture = TEXTURES[new_state]
