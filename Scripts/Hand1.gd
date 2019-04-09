extends Node2D

var display_size = OS.window_size #get current window resolution
var hand_offset = display_size.x/2 + display_size.x/10 #set hand offset amount via division to scale correctly

# Called when the node enters the scene tree for the first time.
func _ready():
	translate(Vector2(hand_offset,display_size.y)) #offset hand origin by screen resolution height and offset width