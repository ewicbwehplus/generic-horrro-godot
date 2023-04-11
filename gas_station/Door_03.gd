extends Node3D
var door_state = false
var player_infront = false
# Called when the node enters the scene tree for the first time.

func _input(event):
	
	if Input.is_action_just_pressed("left_mouse_click"):
		
		if player_infront == true and $AnimationPlayer.is_playing() == false:
			
			door_state = !door_state
			if door_state == true:
				$AnimationPlayer.play("doen")
			else:
				$AnimationPlayer.play("close")


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player_infront == true
		$Label.show()


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		player_infront == false
		$Label.hide()
