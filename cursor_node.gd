extends Node2D


@onready var timer = $Timer

var cursor_speed = 333.0
var global_mouse_pos
var piece_selected = null

var default_cursor : Sprite2D
var option_cursor : Sprite2D
var selected_cursor : Sprite2D
var disabled_cursor : Sprite2D

enum MICE { DEFAULT, OPTION, SELECTED, DISABLED }

var mouse : MICE = MICE.DEFAULT 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide system cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	default_cursor = $Default
	option_cursor = $Option
	selected_cursor = $Selected
	disabled_cursor = $Disabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_mouse_pos = get_global_mouse_position()
	update_cursor_pos(delta, piece_selected)


func update_cursor_pos(delta: float, piece_selected) -> void:
	# Get controller input (Y-axis is inverted in godot)
	var controller_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	# If controller is being used, position follows controller, else it follows mouse
	if controller_vector.length() > 0:
		position += Vector2(controller_vector.x, controller_vector.y) * cursor_speed * delta
		if timer.time_left < 1 and timer.time_left != 0:
			set_cursor_appearance(MICE.SELECTED)
	elif Input.get_last_mouse_velocity() != Vector2(0, 0):
		position = global_mouse_pos
		if timer.time_left < 1 and timer.time_left != 0:
			set_cursor_appearance(MICE.SELECTED)
	
	
	# Clamp cursor to screen
	var viewport_rect = get_viewport().get_visible_rect()
	#position.x = clamp(position.x, viewport_rect.position.x, viewport_rect.position.x -1)
	#position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.position.y -1)


# Function to change the cursor sprite appearance based on selection state
func set_cursor_appearance(new_mouse: MICE = MICE.DEFAULT):
	mouse = new_mouse
	
	if mouse == MICE.SELECTED:
		selected_cursor.visible = true
		default_cursor.visible = false
		option_cursor.visible = false
		disabled_cursor.visible = false
	elif mouse == MICE.OPTION:
		option_cursor.visible = true
		selected_cursor.visible = false
		default_cursor.visible = false
		disabled_cursor.visible = false
	elif mouse == MICE.DISABLED:
		disabled_cursor.visible = true
		timer.start()
		option_cursor.visible = false
		selected_cursor.visible = false
		default_cursor.visible = false
	else:
		default_cursor.visible = true
		option_cursor.visible = false
		selected_cursor.visible = false
		disabled_cursor.visible = false


func _on_timer_timeout() -> void:
	set_cursor_appearance(MICE.SELECTED)
