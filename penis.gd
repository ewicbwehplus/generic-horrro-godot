extends StaticBody3D

@onready var bean = $root/test_world/bean

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		if body.get_name() == "bean":
			$Label.text = "help meeeeee"
