extends CharacterBody3D
#@onready var raycast = $Head/RayCast3D
var sensitivity = 100
var touch_relative_x = 0
var touch_relative_y = 0
const SPEED = 15
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if not $AudioStreamPlayer.is_playing():
			$AudioStreamPlayer.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if $AudioStreamPlayer.is_playing():
			$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stop()
		



	move_and_slide()
	
func _input(event):
	#Move the camera by touchscreen if Touchscreen(Drag to be specific) is detected
	if event is InputEventScreenDrag:
		rotation.y -= event.relative.x / sensitivity
		$Head/Camera3D.rotation.x -= event.relative.y / sensitivity
		$Head/Camera3D.rotation.x = clamp($Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#Limit the values of how much you can turn the camera before it's broken
	touch_relative_x = clamp(event.relative.x, -50, 50)
	touch_relative_y = clamp(event.relative.y, -50, 50)
		
		


		



