extends Node2D


var laser_val = 0
var default_color = Color(255,255,255)
var path_color = Color(255,255,0)
var end_color = Color(0,255,0)
var start_color = Color(0,0,255)

var success_color = Color(0,255,255)
var fail_color = Color(255,0,0)

var success_end_color = Color(0.6, 0.8, 0.2, 1)
var fail_end_color = Color(1, 0.65, 0, 1)

var use_sprite = true
var scaler = 0.1#0.05


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func set_size(size):
    if use_sprite:
        $HexSprite.scale = size*scaler
        $HexSprite.show()
    else:
        get_node("Area2D/OuterRim").scale = size
        get_node("Area2D/MainPoly").scale = size*0.95
        
        $Area2D/OuterRim.show()
        $Area2D/MainPoly.show()

func set_pos(pos):
    if use_sprite:
        $HexSprite.position = pos
    else:
        get_node("Area2D/OuterRim").position = pos
        get_node("Area2D/MainPoly").position = pos
    
func set_color():
    if use_sprite:
        var col_name = "default" if laser_val%2 == 0 else "red"
        $HexSprite.animation = col_name
    else:
        var col = Color(255,0,0) if laser_val%2 == 1 else Color(255,255,255)
        get_node("Area2D/MainPoly").color = col
    
func color():
    if use_sprite:
        $HexSprite.animation = "default"
    else:
        get_node("Area2D/MainPoly").color = default_color
    
func color_path():
    if use_sprite:
        $HexSprite.animation = "yellow"
    else:
        get_node("Area2D/MainPoly").color = path_color

func color_start():
    if use_sprite:
        $HexSprite.animation = "blue"
    else:
        get_node("Area2D/MainPoly").color = start_color
    
func color_end():
    if use_sprite:
        $HexSprite.animation = "green"
    else:
        get_node("Area2D/MainPoly").color = end_color
    
func color_success():
    if use_sprite:
        $HexSprite.animation = "default"
    else:
        get_node("Area2D/MainPoly").color = success_color
    
func color_fail():
    if use_sprite:
        $HexSprite.animation = "default"
    else:
        get_node("Area2D/MainPoly").color = fail_color

func color_success_end():
    if use_sprite:
        $HexSprite.animation = "lightgreen"
    else:
        get_node("Area2D/MainPoly").color = success_end_color
    
func color_fail_end():
    if use_sprite:
        $HexSprite.animation = "orange"
    else:
        get_node("Area2D/MainPoly").color = fail_end_color
    
func make_end_point():
    if use_sprite:
        $HexSprite.animation = "green"
    else:
        get_node("Area2D/MainPoly").color = end_color

func make_start_point():
    if use_sprite:
        $HexSprite.animation = "blue"
    else:
        get_node("Area2D/MainPoly").color = start_color
    
