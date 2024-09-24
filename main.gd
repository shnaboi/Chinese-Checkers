extends Node2D


# References to the tilemaps
var pieces_map
var board_map
var gameboard_cells_array : Array

# Store the selected piece tile position and ID
var selected_piece = null
var selected_piece_pos = null


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
			move_selected_piece(mouse_pos, selected_piece)


# Function to select a piece if clicked
func select_piece(mouse_pos: Vector2):
	# Convert the mouse position to the tile position on the pieces tilemap
	var piece_tile_pos = pieces_map.local_to_map(mouse_pos)

	# Check if there's a piece at the clicked tile
	var piece = pieces_map.get_cell_source_id(piece_tile_pos)

	if piece != -1:  # A piece is present
		selected_piece_pos = piece_tile_pos  # Store the selected piece's position
		selected_piece = piece
		calc_possible_moves(selected_piece_pos) #Pass x,y of piece to calculate moves
		print("Piece selected at: ", selected_piece_pos)
	else:
		print("No piece found at: ", piece_tile_pos)


# Function to move the selected piece to the clicked board space
func move_selected_piece(mouse_pos: Vector2, piece):
	# Convert the mouse position to the tile position on the board tilemap
	var board_tile_pos = board_map.local_to_map(mouse_pos)

	# Check if the clicked space on the board is a valid move (you can add further checks)
	var board_tile = board_map.get_cell_source_id(board_tile_pos)

	if board_tile != -1:  # If the space is valid
		print("Moving piece to: ", board_tile_pos)
		
		# Move the piece in the pieces tilemap
		pieces_map.set_cell(board_tile_pos, selected_piece, pieces_map.get_cell_atlas_coords(selected_piece_pos))
		
		# Remove the piece from the original position
		pieces_map.set_cell(selected_piece_pos, -1)
		
		# Clear the selected piece
		selected_piece = null
		selected_piece_pos = null
	else:
		print("Invalid move. No board space at: ", board_tile_pos)


func calc_possible_moves(selected_piece):
	# Get cells of every piece on the board
	var all_pieces_array = pieces_map.update_used_cells()
	#print(all_pieces_array)
	
#	selected piece can move to any of the 6 neighboring pieces as long as no piece is present
	var neighboring_moves_array : Array
	var neighboring_moves_to_test : Array 
	
	if (selected_piece.y % 2 == 1) :
		# Piece is on odd y coord
		neighboring_moves_to_test = [[-1, 0], [1, 0], [1, -1], [0, -1], [0, 1], [1, 1]]
	else:
		# Piece is on even y coord
		neighboring_moves_to_test = [[-1, 0], [1, 0], [-1, -1], [0, -1], [-1, 1], [0, -1]]
	
	for move in neighboring_moves_to_test:
		var move_vector = Vector2i(move[0], move[1])
		var possible_neighboring_move : Vector2i = selected_piece + move_vector
		
		# Check if there is a piece already at possiible move
		if possible_neighboring_move not in all_pieces_array and possible_neighboring_move not in neighboring_moves_array:
			if possible_neighboring_move in gameboard_cells_array:
				neighboring_moves_array.append(possible_neighboring_move)
		
	print("Neighboring moves = ", neighboring_moves_array)

#	selected piece can move in a straight line if jumping over a present piece
