extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var stuff = int(randf_range(0, 1000))
	match stuff:
		7:
			scale.x = 1.2
			scale.y = 1.2
		13:
			scale.x = 1
			scale.y = 1
