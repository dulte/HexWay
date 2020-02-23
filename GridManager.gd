extends Node2D

onready var SCREEN_SIZE = get_viewport_rect().size

var gridViz = preload("res://GridViz.tscn")
var obsticalViz = preload("res://ObsticalViz.tscn")

var HexGrid = preload("./HexGrid.gd").new()
var size = 30
var cell_size = float(size)/50.0
var board_size = 7

var difficuly = 5

var board = {}
var board_viz = {}

var obsticals = {}
var obstical_viz = {}

var outer_ring = []
var obs_ring = []

var endpoints = []

var player_path = []

func _ready():
    randomize()
    
    
    #HexGrid.hex_scale = Vector2(size, size)
    #create_board()
####################
#For board generation
###################
    
func set_options(boardsize_, difficulty_, size_):
    size = size_
    cell_size = float(size)/50.0
    board_size = boardsize_

    difficuly = difficulty_
    
func create_board():
    
    HexGrid.hex_scale = Vector2(size, size)
    
    var center = Vector2(SCREEN_SIZE.x/2.0, SCREEN_SIZE.y/2.0)
    var center_cell = HexGrid.get_hex_at(center)
    center = HexGrid.get_hex_center(center_cell)
    board[center_cell.axial_coords] = center_cell
    board_viz[center_cell.axial_coords] = create_viz(center)
    
    
    #Makes board
    for i in range(1,board_size):
        var ring = center_cell.get_ring(i)
        if i == board_size-1:
            outer_ring = ring
        for cell in ring:
            var cell_pos = HexGrid.get_hex_center(cell)
            board[cell.axial_coords] = cell
            board_viz[cell.axial_coords] = create_viz(cell_pos)
            
    #Makes obsticals
    obs_ring = center_cell.get_ring(board_size)
    for cell in obs_ring:
            if randi()%len(obs_ring)+1 <= int(difficuly/20.0*len(obs_ring)):
                var cell_pos = HexGrid.get_hex_center(cell)
                obsticals[cell.axial_coords] = cell
                obstical_viz[cell.axial_coords] = create_obs_viz(cell_pos)
                
                
    #Set scores of cells
    for obs_coord in obsticals.keys():
        var obs = obsticals[obs_coord]
        var dirs = obs.DIR_ALL
        for dir in dirs:
            var next_cell = obs.get_adjacent(dir)
            var go_next = true if next_cell.axial_coords in board.keys() else false
            while go_next:
                board[next_cell.axial_coords].laser_val += 1
                board_viz[next_cell.axial_coords].laser_val += 1
                next_cell = next_cell.get_adjacent(dir)
                go_next = true if next_cell.axial_coords in board.keys() else false
        
    
    # Updates color
    #update_viz_colors()
    update_color()
    
    #Finds start and end
    endpoints = get_end_points()
    var start = endpoints[0]
    var end = endpoints[1]
    var dist = endpoints[2]
    
    board_viz[start].make_start_point()
    board_viz[end].make_end_point()
    
    player_path.append(start)
    
    
    
    

func update_viz_colors():
    for obs in board_viz.keys():
        board_viz[obs].set_color()
        
        
func get_end_points():
    HexGrid.set_bounds(Vector2(0,0), SCREEN_SIZE)
    var exc = []
    for index in board.keys():
        if board[index].laser_val%2 == 1:
            HexGrid.add_obstacles(board[index].axial_coords,0)
            exc.append(board[index].axial_coords)
            
    for obs in obs_ring:
        HexGrid.add_obstacles(obs.axial_coords)
        
    
    var pairs = []
    for start in outer_ring:
        if start.laser_val%2 == 1:
                continue
        #print(HexGrid.get_hex_cost(HexGrid.get_hex_center(start)))
        for goal in outer_ring:
            if goal.laser_val%2 == 1:
                continue
            var path = HexGrid.find_path(start.axial_coords, goal.axial_coords, HexGrid.get_obstacles())
            # Something is wrong above...
            if len(path) != 0:
                var dist = len(path)#start.distance_to(goal)
                pairs.append([start.axial_coords, goal.axial_coords, dist])
                
    var best_dist = 0
    var best_start = null
    var best_end = null
    for pair in pairs:
        if pair[2] > best_dist:
            best_dist = pair[2]
            best_start = pair[0]
            best_end = pair[1]
    print([best_start, best_end, best_dist])      
    return [best_start, best_end, best_dist]
        


    
    
        
        
    
    
func create_viz(coord):
    var t = gridViz.instance()
    t.set_size(Vector2(cell_size, cell_size))
    t.set_pos(coord)
    self.add_child(t)
    return t
    
func create_obs_viz(coord):
    var t = obsticalViz.instance()
    t.set_size(Vector2(cell_size, cell_size))
    t.set_pos(coord)
    
    self.add_child(t)
    return t
    
    
####################
#For player input
###################
func make_move(coord):
    var player_cell = HexGrid.get_hex_at(coord)
    var cell_pos = player_cell.axial_coords
    
    if not(cell_pos in board.keys()):
        return [false, null]
        
    if cell_pos == endpoints[1]:
        return [true, check_win()]
        
    var neigh = player_cell.get_all_adjacent()
    for n in neigh:
        var p = n.axial_coords
        if p == player_path[-1]:
            player_path.append(cell_pos)
            return [true, null]
            
    return [false, null]
    

func remove_move(coord):
    var player_cell = HexGrid.get_hex_at(coord)
    var cell_pos = player_cell.axial_coords
    
    if cell_pos == player_path[-1] and len(player_path) > 1:
        player_path.pop_back()
        return true
        
    return false
    
    
func check_win():
    if endpoints[1] != player_path[-1]:
        for step in player_path:
            var cell = board[step]
            var viz = board_viz[step]
            
            if cell.laser_val%2 == 0:
                viz.color_success()
            else:
                viz.color_fail()
                return false
        
        return true
            
        
        
func update_color():
    for index in board_viz.keys():
        board_viz[index].color()
        
    for index in player_path:
        board_viz[index].color_path()
    
    if len(endpoints) != 0:
        board_viz[endpoints[0]].color_start()
        board_viz[endpoints[1]].color_end()
    
        
    
    
    
    

    
    
    

func _unhandled_input(event):
    if 'position' in event:
        var relative_pos = self.transform.affine_inverse() * event.position
        var center_pos = HexGrid.get_hex_center(HexGrid.get_hex_at(relative_pos))
        #print(center_pos)
        #print(HexGrid.get_hex_at(relative_pos).axial_coords)
