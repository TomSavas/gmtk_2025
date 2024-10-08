class_name Board
extends Node

signal should_step(depth: int)
signal on_tetromino_deactivation()


@export var time_dilation := 10.0
@export var step_every_num_sec := 0.5
@export var time_elapsed := 0.0
@export var forced_step := false

static var singleton = null
static func instance() -> Board:
	return singleton
	
@export var width = 10 * 2
@export var height = 18 * 2

var tetrominos: Array[Tetromino] = []
var board: Array[bool] = []

var currently_live_tetromino = null

func _ready():
	singleton = self
	
	board.resize(width * height)
	board.fill(false)

func _check_lines():
	_recalc_board([currently_live_tetromino])
	
	var lines = []
	for y in height:
		var full = true
		for x in width:
			var index = y * width + x
			if not board[index]: 
				full = false
				break
		
		if full:
			lines.append(y)
			
	return lines

func _clear_dead_squares(min_line, max_line):
	for t in tetrominos:
		var depth_scale = pow(2, t.depth)
		var i = 0
		while i < len(t.squares):
			var s = t.squares[i]
			var y = t.topLeftSquare[1] + s.offsetInTetromino[1] * depth_scale
			if min_line <= y and y <= max_line:
				t.swap_remove_square(i)
			else:
				i += 1
	
func _move_all_dead_above(min_line, cleared_line_count):
	for t in tetrominos:
		if t.topLeftSquare[1] >= min_line:
			continue
			
		t.forcedStep(cleared_line_count, Vector2(0.0, 1.0), false)

func _process(delta: float) -> void:
	if time_elapsed > step_every_num_sec or forced_step:
		forced_step = false
		print("Step!")
		should_step.emit(0)
		time_elapsed = 0
		
		if currently_live_tetromino and not currently_live_tetromino.alive:
			currently_live_tetromino = null
			on_tetromino_deactivation.emit()
		
		var lines = _check_lines()
		if len(lines) == 0:
			lines = [0]
		else:
			_clear_dead_squares(lines.min(), lines.max())
			_move_all_dead_above(lines.min(), lines.max() - lines.min() + 1)
			print("clearing!")
		
		#_recalc_board()
	
		#var board_repr = "Board:\n"
		#for y in height:
			#for x in width:
				#var index = y * width + x
				#var marker = "#" if board[index] else "."
				#board_repr += marker
			#board_repr += "\n"
		#print(board_repr + "\n\n")
	
	time_elapsed += delta
	
func _recalc_board(excludes = null):
	board.fill(false)
	for tetromino in tetrominos:
		if excludes != null and tetromino in excludes:
			continue
		for square in tetromino.squares:
			var index = _index(tetromino, square)
			if 0 <= index and index < width*height:
				board[index] = true
			else:
				print("Incorrect index!")
	
func in_bounds(t: Tetromino) -> bool:
	var depth_scale = pow(2, t.depth)
	for s in t.squares:
		var x = t.topLeftSquare[0] + s.offsetInTetromino[0] * depth_scale
		if x < 0 or width <= x:
			return false
			
	return true
	
func above_ground(t: Tetromino) -> bool:
	var depth_scale = pow(2, t.depth)
	for s in t.squares:
		if t.topLeftSquare[1] + s.offsetInTetromino[1] * depth_scale >= height:
			return false
			
	return true
	
func collides(t: Tetromino) -> bool:
	_recalc_board([t, currently_live_tetromino])
	if not above_ground(t) or not in_bounds(t):
		return true
		
	for s in t.squares:
		var index = _index(t, s)
		if index < 0 or index > width * height or board[index]:
			return true
		
	return false
	
func _index(t: Tetromino, s: Square) -> int:
	var depth_scale = pow(2.0, t.depth)
	var offset = t.topLeftSquare + s.offsetInTetromino * depth_scale
	return offset[1] * width + offset[0]
	
func add_tetromino(t: Tetromino): 
	tetrominos.append(t)
	currently_live_tetromino = t
	for square in t.squares:
		board[_index(t, square)] = true
