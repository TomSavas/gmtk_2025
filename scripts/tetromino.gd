class_name Tetromino
extends Node3D

@export var topLeftSquare: Vector2 = Vector2(0, 0)
@export var squares: Array[Square] = []

func _init(squares: Array[Square]) -> void:
	self.squares = squares

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Board.instance().should_step.connect(step)

func step(depth: int):
	self.position.y -= 1.0
	topLeftSquare[1] += 1
	
	# TODO(savas): add some grace period for rotations, etc.
	var board := Board.instance()
	if board.collides(self):
		self.position.y += 1.0
		topLeftSquare[1] -= 1

		board.should_step.disconnect(step)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
