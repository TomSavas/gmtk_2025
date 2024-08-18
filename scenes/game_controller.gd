extends CanvasLayer
class_name GameController

@onready var previewimo: Node3D = $Node3D/BoardBackground/Next/PreviewRoot
@onready var tetrominos = $Node3D/Tetrominos
@onready var camera_3d: Camera3D = $Node3D/SubViewportContainer/SubViewport/Camera3D

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
	tetromino.position -= Vector3(tetromino.rotation_center.x, -tetromino.rotation_center.y, 0.0) / 2.0

	
func get_preview() -> Tetromino:
	var child = previewimo.get_child(0)
	child.position = Vector3.ZERO
	previewimo.remove_child(child)	
	tetrominos.add_child(child)

	return child
