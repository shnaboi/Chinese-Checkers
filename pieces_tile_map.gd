extends TileMapLayer  


var piece_id_dict = {}
var player_count = 1
var all_cells
var option_visual_bool = false

func _ready():
	# Get all the used cells (tiles that have been placed) in this TileMap
	all_cells = get_used_cells()
	
	var init_dict = {}

	# Loop through each cell and print its coordinates
	for cell_pos in all_cells:
		var piece_source_id = get_cell_source_id(cell_pos)
		print("Piece at position: ", cell_pos, " with source ID: ", piece_source_id)
		
		if piece_source_id not in init_dict:
			init_dict[piece_source_id] = player_count
			player_count += 1
	
	for key in init_dict:
		piece_id_dict[init_dict[key]] = key


func _physics_process(delta: float) -> void:
	if option_visual_bool:
		print("aye")
		pass
	pass


func update_used_cells():
	var used_cells = get_used_cells()
	return used_cells


func update_player_pieces(player):
	var past_player = player - 1
	if past_player == 0:
		past_player = 6
	# Update visuals for new player
	var current_player_pieces = get_used_cells_by_id(piece_id_dict[player])
	
	for piece in current_player_pieces:
		set_cell(piece, piece_id_dict[player], Vector2i(1, 0), 0)
	
	# Reset visuals of past player
	var past_player_pieces = get_used_cells_by_id(piece_id_dict[past_player])
	
	for piece in past_player_pieces:
		set_cell(piece, piece_id_dict[past_player], Vector2i(0, 0), 0)


func show_option(piece : Vector2i, id : int):
	reset_option(id)
	set_cell(piece, id, Vector2i(2, 0), 0)
	# set_cell(coords: Vector2i, source_id: int = 1, atlas_coords: Vector2i = Vector2i(0, 0), alternative_tile: int = 0


func reset_option(id):
	var current_player_pieces = get_used_cells_by_id(id)
	
	for piece in current_player_pieces:
		if get_cell_atlas_coords(piece) != Vector2i(2, 0):
			pass
		else:
			set_cell(piece, id, Vector2i(1, 0), 0)
