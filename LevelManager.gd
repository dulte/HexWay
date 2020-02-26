extends Node2D


var boardObj = preload("res://GridManager.tscn")
var board = null

var size = 45
var board_size = 3

var difficuly = 5

var game_over = false

var sceen_size = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    #$Button.connect("button_down", self, "restart")
    #make_board()
    
func start_game(board_size_, difficulty_, screen_size_):
    board_size = board_size_
    difficuly = difficulty_
    sceen_size = screen_size_
    $Button.connect("button_down", self, "restart")
    make_board()
    
func make_board():
    var b = boardObj.instance()
    b._ready()
    b.set_options(board_size, difficuly, size, sceen_size)
    self.add_child(b)
    b.create_board()
    
    board = b
  
func restart():
    remove_child(board)
    make_board()
    game_over = false
    $Button.hide()
    $WinLabel.hide()
    
    
  
func _unhandled_input(event):
    if event is InputEventMouseButton:
        if not game_over:
            if event.button_index == BUTTON_LEFT:
                if event.pressed:
                    var status = board.make_move(event.position)
                    var move = status[0]
                    var end = status[1]
                    
                    if move:
                        board.update_color()
                        if end != null:
                            board.draw_end_board()
                            if end:
                                get_node("WinLabel").text  = "You Win!"
                                print("Win")
                            else:
                                get_node("WinLabel").text  = "You Lose!"
                                print("Lose")
                            #$WinLabel.show()
                            #$Button.show()
                            game_over = true
            if event.button_index == BUTTON_RIGHT:
                if event.pressed: 
                    var move = board.remove_move(event.position)
                    if move:
                        board.update_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
