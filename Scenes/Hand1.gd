extends Node2D

var display_width = OS.window_size #get current window resolution

# Called when the node enters the scene tree for the first time.
func _ready():
	translate(Vector2(display_width.x,display_width.y)) #offset hand origin by screen resolution