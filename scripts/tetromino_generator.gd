class_name TetrominoGenerator
extends Node

const squareScene = preload("res://scenes/square.tscn")
@onready var tetrominos: Node3D = $"../Node3D/Tetrominos"

const width := 3
const height := 4
const rotation_centers = [
	Vector2(1.0, 1.0), # square 
	Vector2(1.5, 1.5), # t-piece
	Vector2(0.5, 1.5), # L
	Vector2(1.5, 1.5), # other L
	Vector2(0.5, 2.0), # long
	Vector2(1.5, 1.5), # S
	Vector2(1.5, 1.5) # Reverse s
]

# 3 x 4
const baseShapes = [
	[ # square 
	1, 1, 0,
	1, 1, 0,
	0, 0, 0,
	0, 0, 0	
	],
	[ # t-piece
	0, 1, 0,
	1, 1, 1,
	0, 0, 0,
	0, 0, 0	
	],
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
	[ # S
	0, 1, 1,
	1, 1, 0,
	0, 0, 0,
	0, 0, 0
	],
	[ # Reverse s
	1, 1, 0,
	0, 1, 1,
	0, 0, 0,
	0, 0, 0
	],
]

static func _generate_tetromino(tetrominos, maxDepth=0) -> Tetromino:
	var shape_index = randi_range(0, len(baseShapes)-1)
	#var shape_index = 
	var baseShape = baseShapes[shape_index]
	var realWidth = pow(2, maxDepth) * width
	var realHeight = pow(2, maxDepth) * height	
	
	var tetromino = Tetromino.new([])
	tetromino.rotation_center = rotation_centers[shape_index]
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

func generate_tetromino():
	var t := _generate_tetromino(tetrominos)
	Board.instance().add_tetromino(t)

static var button_triggered := false
func _on_pressed() -> void:
	if not button_triggered:
		button_triggered = true
		generate_tetromino()
		Board.instance().on_tetromino_deactivation.connect(generate_tetromino)
