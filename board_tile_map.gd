extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var open_cells = get_used_cells()

func get_gameboard_cells():
	var open_cells = get_used_cells()
	return open_cells
