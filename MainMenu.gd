extends Node2D

var levelManager = preload("res://LevelManager.tscn")

var level = null

var difficulty = 1
var size = 3
onready var SCREEN_SIZE = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
    $CenterContainer/VBoxContainer/PlayButton.connect("button_down", self, "play")
    $CenterContainer/VBoxContainer/DifficultyButton.connect("button_down", self, "change_difficulty")
    $CenterContainer/VBoxContainer/SizeButton.connect("button_down", self, "change_size")
    $CenterContainer/VBoxContainer/QuitButton.connect("button_down", self, "quit")
    
    $GameBtnContainer/RestartButton.connect("button_down", self, "restart")
    $GameBtnContainer/QuitButton.connect("button_down", self, "quit_game")


func play():
    $BackHexSprite.hide()
    $BackHexSprite2.hide()
    $CenterContainer.hide()
    $GameBtnContainer.show()
    
    level = levelManager.instance()
    level.start_game(size, difficulty, SCREEN_SIZE)
    add_child(level)
    
func quit_game():
    remove_child(level)
    $BackHexSprite.show()
    $BackHexSprite2.show()
    $CenterContainer.show()
    $GameBtnContainer.hide()
    

func restart():
    remove_child(level)
    play()
    

func change_difficulty():
    difficulty = (difficulty)%9 + 1
    $CenterContainer/VBoxContainer/DifficultyButton.texture_normal = load("Art/diff%s_btn.png" %difficulty)
    
func change_size():
    size = size%7 + 1 if size%7 + 1 > 2 else 3
    $CenterContainer/VBoxContainer/SizeButton.texture_normal = load("Art/size%s_btn.png" %size)
