extends Node2D


# References to the tilemaps
var pieces_map
var board_map
var gameboard_cells_array : Array

# Store the selected piece tile position and ID
var selected_piece = null
var selected_piece_pos = null

# Declare possible moves array
var possible_moves_array : Array

# Dicts of vectors (arrays) for vector math on possible moves
var neighboring_vectors_odd_y_dict : Dictionary = {
	"left": [-1, 0],
	"right": [1, 0],
	"up_left": [0, -1],
	"up_right": [1, -1],
	"down_left": [0, 1],
	"down_right": [1, 1]
}

var neighboring_vectors_even_y_dict : Dictionary = {
	"left": [-1, 0],
	"right": [1, 0],
	"up_left": [-1, -1],
	"up_right": [0, -1],
	"down_left": [-1, 1],
	"down_right": [0, -1]
}

var skippable_moves : Dictionary = {
	"left": [-2, 0],
	"right": [2, 0],
	"up_left": [-1, -2],
	"up_right": [1, -2],
	"down_left": [-1, 2],
	"down_right": [1, 2]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get references to the tilemaps
	pieces_map = $PiecesTileMap  # Tilemap for pieces
	board_map = $BoardTileMap    # Tilemap for the board spaces
	gameboard_cells_array = board_map.get_gameboard_cells()


# Detect mouse input
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()

		if selected_piece_pos == null:
			# Try to select a piece
			select_piece(mouse_pos)
		else:
			# Try to move the piece to the selected board space
			move_selected_piece(mouse_pos, selected_piece, possible_moves_array)


# Function to select a piece if clicked
func select_piece(mouse_pos: Vector2):
	# Convert the mouse position to the tile position on the pieces tilemap
	var piece_tile_pos = pieces_map.local_to_map(mouse_pos)

	# Check if there's a piece at the clicked tile
	var piece = pieces_map.get_cell_source_id(piece_tile_pos)

	if piece != -1:  # A piece is present
		selected_piece_pos = piece_tile_pos  # Store the selected piece's position
		selected_piece = piece
		possible_moves_array = calc_possible_moves(selected_piece_pos) #Pass x,y of piece to calculate moves
		print("Piece selected at: ", selected_piece_pos)
	else:
		print("No piece found at: ", piece_tile_pos)


# Function to move the selected piece to the clicked board space
func move_selected_piece(mouse_pos: Vector2, piece, possible_moves):
	# Convert the mouse position to the tile position on the board tilemap
	var board_tile_pos = board_map.local_to_map(mouse_pos)

	# Check if the clicked space on the board is a valid move (you can add further checks)
	var board_tile = board_map.get_cell_source_id(board_tile_pos)

	if board_tile_pos in possible_moves_array:  # If the move is valid after calculation
		print("Moving piece to: ", board_tile_pos)
		
		# Move the piece in the pieces tilemap
		pieces_map.set_cell(board_tile_pos, selected_piece, pieces_map.get_cell_atlas_coords(selected_piece_pos))
		
		# Remove the piece from the original position
		pieces_map.set_cell(selected_piece_pos, -1)
		
		# Clear the selected piece
		selected_piece = null
		selected_piece_pos = null
		# Reset possible_moves_array
		possible_moves_array = []
	else:
		print("Invalid move at: ", board_tile_pos)


func calc_possible_moves(selected_piece_cell):
	# Get cells of every piece on the board
	var all_pieces_array : Array = pieces_map.update_used_cells()
	var neighboring_moves : Array
	var skippable_moves : Array
	var all_possible_moves : Array
	
	var odd_y : bool
	
	if (selected_piece_cell.y % 2 == 1):
		# Piece is on odd y coord
		odd_y = true
	else:
		# Piece is on even y coord
		odd_y = false
	
	neighboring_moves = calc_neighboring_moves(selected_piece_cell, all_pieces_array, odd_y)
	
	skippable_moves = calc_skippable_moves(selected_piece_cell, all_pieces_array, odd_y)
	
	all_possible_moves = neighboring_moves + skippable_moves
	
	print("Neighbor moves: ", neighboring_moves, "Skipping moves: ", skippable_moves)
	print(all_possible_moves)
	
	return all_possible_moves


func calc_neighboring_moves(selected_piece_cell, all_pieces, odd_y):
#	selected piece can move to any of the 6 neighboring pieces as long as no piece is present
	var neighboring_moves_array : Array
	
	if odd_y:
		for move in neighboring_vectors_odd_y_dict:
			var move_vector = Vector2i(neighboring_vectors_odd_y_dict[move][0], neighboring_vectors_odd_y_dict[move][1])
			var possible_neighboring_move : Vector2i = selected_piece_cell + move_vector
		
			# Check if there is a piece already at possiible move and that it's on the game board
			if possible_neighboring_move not in all_pieces and possible_neighboring_move not in neighboring_moves_array:
				if possible_neighboring_move in gameboard_cells_array:
					neighboring_moves_array.append(possible_neighboring_move)
	
	else:
		for move in neighboring_vectors_even_y_dict:
			var move_vector = Vector2i(neighboring_vectors_even_y_dict[move][0], neighboring_vectors_even_y_dict[move][1])
			var possible_neighboring_move : Vector2i = selected_piece_cell + move_vector
		
			# Check if there is a piece already at possiible move and that it's on the game board
			if possible_neighboring_move not in all_pieces and possible_neighboring_move not in neighboring_moves_array:
				if possible_neighboring_move in gameboard_cells_array:
					neighboring_moves_array.append(possible_neighboring_move)
		
	return neighboring_moves_array


#func calc_skippable_moves(selected_piece_cell, all_pieces, odd_y):
	#
	#var skipping_moves_array : Array = []
	#
	#for move in skippable_moves:
		#var move_vector = Vector2i(skippable_moves[move][0], skippable_moves[move][1])
		#var possible_skipping_move : Vector2i = selected_piece_cell + move_vector
		#
		## Check if skip is possble > cell is available on the board 
		#if possible_skipping_move not in all_pieces and possible_skipping_move in gameboard_cells_array and possible_skipping_move not in skipping_moves_array:
			## Check the middle cell for a piece. If true, then skip is possible
			#if odd_y:
				#var vector_math = Vector2i(neighboring_vectors_odd_y_dict[move][0], neighboring_vectors_odd_y_dict[move][1])
				#var middle_cell = selected_piece_cell + vector_math
				#if middle_cell in all_pieces:
					#skipping_moves_array.append(possible_skipping_move)
			#
			#else:
				#var vector_math = Vector2i(neighboring_vectors_even_y_dict[move][0], neighboring_vectors_even_y_dict[move][1])
				#var middle_cell = selected_piece_cell + vector_math
				#if middle_cell in all_pieces:
					#skipping_moves_array.append(possible_skipping_move)
	#
	#return skipping_moves_array

func calc_skippable_moves(selected_piece_cell, all_pieces, odd_y, skipping_moves_array = []):
	var new_skips : Array = []

	for move in skippable_moves:
		var move_vector = Vector2i(skippable_moves[move][0], skippable_moves[move][1])
		var possible_skipping_move : Vector2i = selected_piece_cell + move_vector

		# Check if skip is possible > cell is available on the board 
		if (
			possible_skipping_move not in all_pieces and 
			possible_skipping_move in gameboard_cells_array and
			possible_skipping_move not in skipping_moves_array
			):
			# Check the middle cell for a piece. If true, then skip is possible
			if odd_y:
				var vector_math = Vector2i(neighboring_vectors_odd_y_dict[move][0], neighboring_vectors_odd_y_dict[move][1])
				var middle_cell = selected_piece_cell + vector_math
				if middle_cell in all_pieces:
					skipping_moves_array.append(possible_skipping_move)
					new_skips.append(possible_skipping_move)
			else:
				var vector_math = Vector2i(neighboring_vectors_even_y_dict[move][0], neighboring_vectors_even_y_dict[move][1])
				var middle_cell = selected_piece_cell + vector_math
				if middle_cell in all_pieces:
					skipping_moves_array.append(possible_skipping_move)
					new_skips.append(possible_skipping_move)

	# Recursively check for further skips from new positions
	for skip in new_skips:
		calc_skippable_moves(skip, all_pieces, odd_y, skipping_moves_array)

	return skipping_moves_array
