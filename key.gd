extends Node3D

var key_picked = false
var player_infront = false

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player_infront == true
		$Label.show()
	if Key.key_picked == false:
			Key.key_picked == true
			$Label.hide()
			queue_free()
		



func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		player_infront == false
	if Key.key_picked == false:
		$Label.hide()
		
	
