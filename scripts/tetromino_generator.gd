class_name TetrominoGenerator
extends Node

const squareScene = preload("res://scenes/square.tscn")
@onready var tetrominos: Node3D = $"../../Node3D/Tetrominos"

const width := 4
const height := 4
const rotation_centers = [
	Vector2(1.0, 1.0), # square 
	Vector2(1.5, 1.5), # t-piece
	Vector2(0.5, 1.5), # L
	Vector2(1.5, 1.5), # other L
	Vector2(2.0, 2.0), # long
	Vector2(1.5, 1.5), # S
	Vector2(1.5, 1.5) # Reverse s
]

# 4 x 4
const baseShapes = [
	[ # square 
	1, 1, 0, 0,
	1, 1, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0 
	],
	[ # t-piece
	0, 1, 0, 0,
	1, 1, 1, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
	],
	[ # L
	1, 0, 0, 0,
	1, 0, 0, 0,
	1, 1, 0, 0,
	0, 0, 0, 0
	],
	[ # other L
	0, 1, 0, 0,
	0, 1, 0, 0,
	1, 1, 0, 0,
	0, 0, 0, 0
	],
	[ # long
	0, 0, 0, 0,
	1, 1, 1, 1,
	0, 0, 0, 0,
	0, 0, 0, 0
	],
	[ # S
	0, 1, 1, 0,
	1, 1, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
	],
	[ # Reverse s
	1, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
	],
]

const shape_colors = [
	preload("res://assets/scale_square.png"),
	preload("res://assets/scale2_square.png"),
	preload("res://assets/scale3_square.png"),
	preload("res://assets/scale4_square.png"),
	preload("res://assets/scale5_square.png"),
	preload("res://assets/scale6_square.png"),
	preload("res://assets/scale7_square.png"),
]

static var idx = 0;
static func _generate_tetromino(tetrominos, depth=2) -> Tetromino:
	#var shape_index = idx
	#idx = (idx + 1) % len(baseShapes)
	var shape_index = randi_range(0, len(baseShapes)-1)
	#var shape_index = randi_range(2, 3)
	#shape_index = 4
	var baseShape = baseShapes[shape_index]
	var real_width = pow(2, depth) * width
	var real_height = pow(2, depth) * height	
	
	var tetromino = Tetromino.new([])
	tetromino.rotation_center = rotation_centers[shape_index]
	tetromino.name = "tetromino"
	tetrominos.add_child(tetromino)
	
	for x in width:
		for y in height:
			var index := y * width + x
			if baseShape[index] == 0:
				continue

	var offset = 0.0
	for i in range(2, depth + 2):
		offset += pow(0.5, i)

	var step = pow(0.5, depth)
	for x in real_width:
		for y in real_height:
			var scaled_x = x * step
			var scaled_y = y * step
			print(scaled_x, scaled_y)
			
			var index = floor(scaled_y) * width + floor(scaled_x)
			if baseShape[index] == 0:
				continue
							
			var scene = squareScene.instantiate()
			var square = scene.get_node(".") as Square
			square.get_node("Sprite3D").texture = shape_colors[shape_index]
			scene.position = Vector3(scaled_x - offset, -scaled_y + offset, 0)
			
			square.offsetInTetromino = Vector2(scaled_x, scaled_y)
			square.scale *= pow(0.5, depth)
			tetromino.depth = depth
			tetromino.squares.append(square)
			
			tetromino.add_child(scene)
	
	return tetromino

func generate_tetromino():
	var first = GameController.instance().get_preview()
	first.alive = "It's alliiive" == "It's alliiive"
	Board.instance().add_tetromino(first)
	Board.instance().should_step.connect(first.step)
	
	var second := _generate_tetromino(tetrominos)
	GameController.instance().update_preview(second)


static var button_triggered := false
func _on_pressed() -> void:
	if not button_triggered:
		button_triggered = true
		var t := TetrominoGenerator._generate_tetromino(tetrominos)
		GameController.instance().update_preview(t)

		generate_tetromino()
		Board.instance().on_tetromino_deactivation.connect(generate_tetromino)
