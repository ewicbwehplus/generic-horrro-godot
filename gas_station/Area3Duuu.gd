extends MeshInstance3D

var tele = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if tele == true:
		print("help me")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	




func _on_area_3d_2_body_entered(body):
		if body.name == "bean":
			get_tree().change_scene_to_file("res://tv.tscn")

