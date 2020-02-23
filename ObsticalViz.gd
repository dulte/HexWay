extends Node2D


var BLACK = Color(255,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


func set_size(size):
    get_node("Area2D/Polygon2D").scale = size*0.2
    

func set_pos(pos):
    get_node("Area2D/Polygon2D").position = pos
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
