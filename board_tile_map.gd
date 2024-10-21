extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var open_cells = get_used_cells()

func get_gameboard_cells():
	var open_cells = get_used_cells()
	return open_cells

func show_possible_moves(move_coord_v2i):
	erase_cell(move_coord_v2i)
	set_cell(move_coord_v2i, 0, Vector2i(0, 0), 0)
	# set_cell(coords: Vector2i, source_id: int = 1, atlas_coords: Vector2i = Vector2i(0, 0), alternative_tile: int = 0)

func erase_previous_possible_moves():
	var previous_possible_moves_array = get_used_cells_by_id(0, Vector2i(0, 0), 0)
	for cell in previous_possible_moves_array:
		set_cell(cell, 0, Vector2i(1, 0), 0)
