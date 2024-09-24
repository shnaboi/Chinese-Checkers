extends TileMapLayer  

func _ready():
	# Get all the used cells (tiles that have been placed) in this TileMap
	var used_cells = get_used_cells()

	# Loop through each cell and print its coordinates
	for cell_pos in used_cells:
		var piece_source_id = get_cell_source_id(cell_pos)
		print("Piece at position: ", cell_pos, " with source ID: ", piece_source_id)

func update_used_cells():
	var used_cells = get_used_cells()
	return used_cells
