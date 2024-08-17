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

func forcedStep(step_count=1, undo=false):
	self.position.y -= (-1.0 if undo else 1.0) * step_count
	topLeftSquare[1] += (-1 if undo else 1) * step_count
	
func step(depth: int = 0):
	forcedStep()
	
	# TODO(savas): add some grace period for rotations, etc.
	var board := Board.instance()
	if board.collides(self):
		forcedStep(1, true)
		board.should_step.disconnect(step)
		alive = false

func swap_remove_square(index: int):
	var temp = squares[-1]
	squares[-1] = squares[index]
	squares[index] = temp
	squares.pop_back().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
