extends CanvasLayer
class_name GameController

@onready var previewimo = $Node3D/PreviewRoot
@onready var tetrominos = $Node3D/Tetrominos

static var singleton = null
static func instance() -> GameController:
	return singleton

func _ready() -> void:
	singleton = self	
	
func update_preview(tetromino: Tetromino):
	if previewimo.get_child_count() > 0:
		previewimo.remove_child(previewimo.get_child(0))
	
	tetrominos.remove_child(tetromino)	
	previewimo.add_child(tetromino)
	tetromino.position = Vector3.ZERO


	
func get_preview() -> Tetromino:
	var child = previewimo.get_child(0)
	previewimo.remove_child(child)	
	tetrominos.add_child(child)

	return child
