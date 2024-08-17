class_name Board
extends Node

signal should_step(depth: int)

@export var time_dilation := 10.0
@export var step_every_num_sec := 0.3
@export var time_elapsed := 0.0

static var singleton = null
static func instance() -> Board:
	return singleton
	
@export var width = 10
@export var height = 18

var tetrominos: Array[Tetromino] = []
var board: Array[bool] = []

func _ready():
	singleton = self
	
	board.resize(width * height)
	board.fill(false)

func _process(delta: float) -> void:
	if time_elapsed > step_every_num_sec:
		print("Step!")
		should_step.emit(0)
		time_elapsed = 0
		
	var lines = _check_lines()
	_clear_lines(lines)
	
	_recalc_board()
	
	print("Board:")
	for y in height:
		var line = ""
		for x in width:
			var index = y * width + x
			var marker = "X" if board[index] else "0"
			line += marker
		print(line)
	print()
	
	time_elapsed += delta
	
func _check_lines():
	return null
	
func _clear_lines(lines):
	pass
	
func _recalc_board(exclude = null):
	board.fill(false)
	for tetromino in tetrominos:
		if exclude != null and tetromino == exclude:
			continue
		for square in tetromino.squares:
			board[_index(tetromino, square)] = true
	
func in_bounds(t: Tetromino) -> bool:
	for s in t.squares:
		if t.topLeftSquare[1] + s.offsetInTetromino[1] >= height:
			return false
			
	return true
	
func collides(t: Tetromino) -> bool:
	_recalc_board(t)
	if not in_bounds(t):
		return true
		
	for s in t.squares:
		if board[_index(t, s)]:
			return true
		
	return false
	
func _index(t: Tetromino, s: Square) -> int:
	var x = t.topLeftSquare[0] + s.offsetInTetromino[0]
	var y = t.topLeftSquare[1] + s.offsetInTetromino[1]
	return y * width + x
	
func add_tetromino(t: Tetromino): 
	tetrominos.append(t)
	for square in t.squares:
		board[_index(t, square)] = true
