extends Node2D


var boardObj = preload("res://GridManager.tscn")
var board = null

var size = 50
var board_size = 6

var difficuly = 7

var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
    var b = boardObj.instance()
    b.set_options(board_size, difficuly, size)
    self.add_child(b)
    b.create_board()
    
    board = b
    
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
                            if end:
                                get_node("WinLabel").text  = "You Win!"
                                print("Win")
                            else:
                                get_node("WinLabel").text  = "You Lose!"
                                print("Lose")
                            
                            get_node("WinLabel").show()
                            game_over = true
                    print("Left button was clicked at ", event.position)
            if event.button_index == BUTTON_RIGHT:
                if event.pressed: 
                    var move = board.remove_move(event.position)
                    if move:
                        board.update_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
