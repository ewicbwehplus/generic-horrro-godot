extends StaticBody3D

#The status of the light when it can or can't interactable
var on = true

func Interact():

	on =!on
#Action that the game would process if it's in its interactable state (check the Raycast3D.gd file)
	if on == true:
		$SpotLight3D.visible = true
	
#Same thing but if it's not in its interactable state
	if on == false:
		$SpotLight3D.visible = false
