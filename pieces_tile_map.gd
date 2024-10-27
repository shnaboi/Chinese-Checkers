extends TileMapLayer  


var piece_id_dict = {}
var player_count = 1

func _ready():
	# Get all the used cells (tiles that have been placed) in this TileMap
	var used_cells = get_used_cells()
	
	var init_dict = {}

	# Loop through each cell and print its coordinates
	for cell_pos in used_cells:
		var piece_source_id = get_cell_source_id(cell_pos)
		print("Piece at position: ", cell_pos, " with source ID: ", piece_source_id)
		
		if piece_source_id not in init_dict:
			init_dict[piece_source_id] = player_count
			player_count += 1
	
	for key in init_dict:
		piece_id_dict[init_dict[key]] = key

func update_used_cells():
	var used_cells = get_used_cells()
	return used_cells
