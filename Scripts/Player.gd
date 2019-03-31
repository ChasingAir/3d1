extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 5

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseMotion: #If there is mouse input
		$Head.rotate_y(deg2rad(-event.relative.x * .05 * mouse_sensitivity)) #Rotate head
		
		var change = event.relative.y * .05 * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_z(deg2rad(change))
			camera_angle += change