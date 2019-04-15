extends KinematicBody

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (!is_on_floor()):
		move_and_collide(Vector3(0,-1,0))