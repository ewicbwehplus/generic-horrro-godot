extends Node3D

var isOpen = false
var canInteract = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func action_use():
	if !isOpen and canInteract:
	
		
