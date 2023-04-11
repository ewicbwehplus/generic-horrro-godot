extends MeshInstance3D

var a = 0.1

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	rotation.x += 0.1
	a += 0.01
	rotation_degrees.y = sin(a) * 180


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
