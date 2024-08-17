class_name Tetromino
extends Node3D

@export var topLeftSquare: Vector2 = Vector2(0, 0)
@export var squares: Array[Square] = []
@export var alive: bool = true

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
