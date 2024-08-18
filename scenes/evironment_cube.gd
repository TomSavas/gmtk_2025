extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = Vector2(3, 3)
	var s = Vector2(1, 0)
	
	var width = 10
	var fuck_you = t + s
	print(fuck_you[1] * width + fuck_you[0])
	
	var x = t[0] + s[0]
	var y = t[1] + s[1]
	print(y * width + x)
