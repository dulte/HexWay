extends Node2D


var laser_val = 0
var default_color = Color(255,255,255)
var path_color = Color(255,255,0)
var end_color = Color(0,255,0)
var start_color = Color(0,0,255)

var success_color = Color(0,255,255)
var fail_color = Color(255,0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func set_size(size):
    get_node("Area2D/OuterRim").scale = size
    get_node("Area2D/MainPoly").scale = size*0.95

func set_pos(pos):
    get_node("Area2D/OuterRim").position = pos
    get_node("Area2D/MainPoly").position = pos
    
func set_color():
    var col = Color(255,0,0) if laser_val%2 == 1 else Color(255,255,255)
    get_node("Area2D/MainPoly").color = col
    
func color():
    get_node("Area2D/MainPoly").color = default_color
    
func color_path():
    get_node("Area2D/MainPoly").color = path_color

func color_start():
    get_node("Area2D/MainPoly").color = start_color
    
func color_end():
    get_node("Area2D/MainPoly").color = end_color
    
func color_success():
    get_node("Area2D/MainPoly").color = success_color
    
func color_fail():
    get_node("Area2D/MainPoly").color = fail_color
    
func make_end_point():
    get_node("Area2D/MainPoly").color = end_color

func make_start_point():
    get_node("Area2D/MainPoly").color = start_color
    
