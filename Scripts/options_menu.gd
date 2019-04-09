extends Node2D

var display_size = OS.window_size #get screen size
var display_center = Vector2(display_size.x/2,display_size.y/2) #get screen center
var window_type_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	translate(Vector2(display_center.x,display_center.y)) #move main_menu background to center
	
	add_window_type()

func add_window_type():
	$OptionButton.add_item("Fullscreen")
	$OptionButton.add_item("Borderless Window")
	$OptionButton.add_item("Windowed")

func _input(event):
	if  Input.is_mouse_button_just_pressed(BUTTON_LEFT):
		window_type_id = $OptionButton.get_selected_metadata()
		print_debug(window_type_id)