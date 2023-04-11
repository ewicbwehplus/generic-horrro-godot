extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_finished():
	if $AudioStreamPlayer.stop():
		$AudioStreamPlayer.play()


func _on_69_body_entered(body):
	pass # Replace with function body.
