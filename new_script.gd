extends Node3D


var player_infront = false

var door_state = false


func _input(event):
	
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player_infront = true
		$Label.show()
