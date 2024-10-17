extends Node2D

var cursor_speed = 333.0
var old_mouse_pos

@export var default_cursor : Sprite2D
@export var option_cursor : Sprite2D
@export var selected_cursor : Sprite2D
@export var disabled_cursor : Sprite2D



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
	update_cursor_pos(delta)


func update_cursor_pos(delta: float) -> void:
	# Get mouse pos
	#var mouse_pos = get_viewport().get_mouse_position()
	var global_mouse_pos = get_global_mouse_position()
	#position = global_mouse_pos
	
	# Get controller input (Y-axis is inverted in godot)
	var controller_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	# If controller is being used, position follows controller, else it follows mouse
	if controller_vector.length() > 0:
		position += Vector2(controller_vector.x, controller_vector.y) * cursor_speed * delta
	elif global_mouse_pos != position:
		position = global_mouse_pos
		

	
	# Clamp cursor to screen
	#var viewport_rect = get_viewport().get_visible_rect()
	#position.x = clamp(position.x, viewport_rect.position.x, viewport_rect.position.x -1)
	#position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.position.y -1)


# Function to change the cursor sprite appearance based on selection state
func set_cursor_appearance(is_selected: bool) -> void:
	if is_selected:
		selected_cursor.visible = true
		default_cursor.visible = false
	else:
		selected_cursor.visible = false
		default_cursor.visible = true
