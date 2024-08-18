class_name Tetromino
extends Node3D

@export var topLeftSquare: Vector2 = Vector2(0, 0)
@export var squares: Array[Square] = []
@export var alive: bool = true
@export var rotation_center: Vector2 = Vector2(0, 0)
@export var depth = 0

func _init(squares: Array[Square]) -> void:
	self.squares = squares

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Board.instance().should_step.connect(step)

func _step_count():
	return pow(2, depth)

func forcedStep(step_count=1, dir=Vector2(0.0, 1.0), undo=true):
	var depth_scale = pow(0.5, depth)
	for i in max(1, step_count):
		self.position += Vector3(dir[0], -dir[1], 0) * depth_scale
		topLeftSquare += dir
		
		var board := Board.instance()
		if undo and board.collides(self):
			self.position -= Vector3(dir[0], -dir[1], 0) * depth_scale
			topLeftSquare -= dir
			return false
	
	return true
	
func _unsafe_rotate(clockwise=true):
	var offset = 0.0
	for i in range(2, depth + 2):
		offset += pow(0.5, i)
	
	var depth_scale = pow(0.5, depth)
	for s in squares:
		# move the origin to center of mass
		s.offsetInTetromino += Vector2(0.5, 0.5) * depth_scale
		s.offsetInTetromino -= rotation_center
		# rotate around the origin by pi/2
		s.offsetInTetromino = s.offsetInTetromino.rotated(PI / 2 * (1.0 if clockwise else -1.0))
		# undo origin translation
		s.offsetInTetromino += rotation_center
		s.offsetInTetromino -= Vector2(0.5, 0.5) * depth_scale
		s.offsetInTetromino = Vector2(round(s.offsetInTetromino[0] / depth_scale) * depth_scale, round(s.offsetInTetromino[1] / depth_scale) * depth_scale)
		#s.position = Vector3(s.offsetInTetromino[0], -s.offsetInTetromino[1], s.position.z)

		s.position = Vector3(s.offsetInTetromino[0] - offset, -s.offsetInTetromino[1] + offset, 0)

	
func _rotateUndo() -> bool:
	_unsafe_rotate(true)

	var board := Board.instance()
	if board.collides(self):
		_unsafe_rotate(false)
		return false
		
	return true

func _rotate():
	if _rotateUndo():
		return
		
	var moveSuceeded = forcedStep(_step_count(), Vector2(-1.0, 0.0), true)
	if moveSuceeded and _rotateUndo():
		return
			
	moveSuceeded = forcedStep(_step_count(), Vector2(1.0, 0.0), true)
	if moveSuceeded and _rotateUndo():
		return
	
func step(depth: int = 0):
	if not forcedStep(_step_count(), Vector2(0.0, 1.0), true):
	# TODO(savas): add some grace period for rotations, etc.
		Board.instance().should_step.disconnect(step)
		alive = false
		set_process(false)

func swap_remove_square(index: int):
	var temp = squares[-1]
	squares[-1] = squares[index]
	squares[index] = temp
	squares.pop_back().queue_free()

@export var default_cooldown = 0.075
@export var action_cooldowns = {}
func _action_with_cooldown(action, fn):
	if action not in action_cooldowns:
		action_cooldowns[action] = 0
		
	if Input.is_action_pressed(action):
		if action_cooldowns[action] <= 0:
			action_cooldowns[action] = default_cooldown
			fn.call()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for key in action_cooldowns:
		action_cooldowns[key] -= delta
		
	_action_with_cooldown('left', func(): forcedStep(_step_count(), Vector2(-1.0, 0.0), true))
	_action_with_cooldown('right', func(): forcedStep(_step_count(), Vector2(1.0, 0.0), true))
	_action_with_cooldown('down', func(): Board.instance().forced_step = true)

	if Input.is_action_just_pressed('rotate'):
		_rotate()
		
	if Input.is_action_just_pressed('drop'):
		forcedStep(_step_count() * 20, Vector2(0.0, 1.0), true)
