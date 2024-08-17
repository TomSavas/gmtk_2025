class_name TetrominoGenerator
extends Node

const squareScene = preload("res://scenes/square.tscn")
@onready var tetrominos: Node3D = $"../Tetrominos"

const width := 3
const height := 4
# 3 x 4
const baseShapes = [
	[ # square 
	1, 1, 0,
	1, 1, 0,
	0, 0, 0,
	0, 0, 0	
	],
	#[ # t-piece
	#0, 1, 0,
	#1, 1, 1,
	#0, 0, 0,
	#0, 0, 0	
	#],
	[ # L
	1, 0, 0,
	1, 0, 0,
	1, 1, 0,
	0, 0, 0	
	],
	[ # other L
	0, 1, 0,
	0, 1, 0,
	1, 1, 0,
	0, 0, 0	
	],
	[ # long
	1, 0, 0,
	1, 0, 0,
	1, 0, 0,
	1, 0, 0	
	],
	#[ # S
	#0, 1, 1,
	#1, 1, 0,
	#0, 0, 0,
	#0, 0, 0
	#],
	#[ # Reverse s
	#1, 1, 0,
	#0, 1, 1,
	#0, 0, 0,
	#0, 0, 0
	#],
]

static func generateTetromino(tetrominos, maxDepth=0) -> Tetromino:
	var baseShape = baseShapes[randi_range(0, len(baseShapes)-1)]
	var realWidth = pow(2, maxDepth) * width
	var realHeight = pow(2, maxDepth) * height	
	
	var tetromino = Tetromino.new([])
	tetromino.name = "tetromino"
	tetrominos.add_child(tetromino)
	
	for x in width:
		for y in height:
			var index := y * width + x
			if baseShape[index] == 0:
				continue
				
			var scene = squareScene.instantiate()
			var square = scene.get_node(".") as Square
			scene.position = Vector3(x, -y, 0)
			
			square.offsetInTetromino = Vector2(x, y)
			tetromino.squares.append(square)
			
			tetromino.add_child(scene)
				
			#for x_offset in pow(2, maxDepth) + 1:
				#for y_offset in pow(2, maxDepth) + 1:
					#var scene = squareScene.instantiate()
					#tetromino.add_child(scene)
					##scene.reparent(tetromino)
					##var square = scene.get_script() as Square
					#
					##square.offsetInTetromino = Vector2(x + x_offset, y + y_offset)
					##tetromino.squares.append(square)
					
	return tetromino


func _on_pressed() -> void:
	# TEMP(savas): for debugging purposes
	#for child in tetrominos.get_children():
		#child.queue_free()

	var t := generateTetromino(tetrominos)
	Board.instance().add_tetromino(t)
