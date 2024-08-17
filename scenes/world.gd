extends Node3D

@export var width = 10
@export var height = 18
var tilemap = []
var current_piece: Tetromino = null
var current_depth: int = 0
@onready var camera = $Camera3D
@export var depth_slow_down = 0.5
var square_scene = preload("res://scenes/square.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_tilemap()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#current_piece.fall(delta * pow(depth_slow_down, current_depth))
	pass

func create_tilemap():
	var true_width = width * 16
	var true_height = height * 16
	tilemap.resize(true_width)
	for i in true_width:
		tilemap[i] = []
		tilemap[i].resize(true_height)
		for j in true_height:
			var square: Square = square_scene.instantiate().get_node(".")
			square.position = Vector3(randf(), randf(), randf())
			self.add_child(square)
			tilemap[i][j] = square
			
		
	print("Done")
