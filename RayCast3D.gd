extends RayCast3D


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coll = self.get_collider()
	
	
	if self.is_colliding():
		if coll.is_in_group("Pickable"):
			$Interact.show()
			if Input.is_action_just_pressed("left_mouse_click"):
				coll.Interact()
	else:
		$Interact.hide()
