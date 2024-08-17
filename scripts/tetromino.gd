class_name Tetromino
extends Node3D

@export var topLeftSquare: Vector2 = Vector2(0, 0)
@export var squares: Array[Square] = []
@export var alive: bool = true
@export var rotation_center: Vector2 = Vector2(0, 0)

func _init(squares: Array[Square]) -> void:
	self.squares = squares

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Board.instance().should_step.connect(step)

func forcedStep(step_count=1, dir=Vector2(0.0, 1.0), undo=true):
	self.position += Vector3(dir[0], -dir[1], 0) * step_count
	topLeftSquare += dir * step_count
	
	var board := Board.instance()
	if undo and board.collides(self):
		self.position -= Vector3(dir[0], -dir[1], 0) * step_count
		topLeftSquare -= dir * step_count
		return false
		
	return true
	
func _rotate(undo=true):
	for s in squares:
		# move the origin to center of mass
		s.offsetInTetromino += Vector2(0.5, 0.5)
		s.offsetInTetromino -= rotation_center
		# rotate around the origin by pi/2
		s.offsetInTetromino = s.offsetInTetromino.rotated(PI / 2)
		# undo origin translation
		s.offsetInTetromino += rotation_center
		s.offsetInTetromino -= Vector2(0.5, 0.5)
		s.position = Vector3(s.offsetInTetromino[0], s.offsetInTetromino[1], s.position.z)

	var board := Board.instance()
	if undo and board.collides(self):
		for s in squares:
			# move the origin to center of mass
			s.offsetInTetromino += Vector2(0.5, 0.5)
			s.offsetInTetromino -= rotation_center
			# rotate around the origin by pi/2
			s.offsetInTetromino = s.offsetInTetromino.rotated(-PI / 2)
			# undo origin translation
			s.offsetInTetromino += rotation_center
			s.offsetInTetromino -= Vector2(0.5, 0.5)
			s.position = Vector3(s.offsetInTetromino[0], s.offsetInTetromino[1], s.position.z)

	
func step(depth: int = 0):
	if not forcedStep(1, Vector2(0.0, 1.0), true):
	# TODO(savas): add some grace period for rotations, etc.
		Board.instance().should_step.disconnect(step)
		alive = false
		set_process(false)

func swap_remove_square(index: int):
	var temp = squares[-1]
	squares[-1] = squares[index]
	squares[index] = temp
	squares.pop_back().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('left'):
		forcedStep(1, Vector2(-1.0, 0.0), true)
		
	if Input.is_action_just_pressed('right'):
		forcedStep(1, Vector2(1.0, 0.0), true)
		
	if Input.is_action_just_pressed('rotate'):
		_rotate(true)
