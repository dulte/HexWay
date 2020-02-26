extends Node2D

var levelManager = preload("res://LevelManager.tscn")

var level = null

var difficulty = 1
var size = 3

var tutoral_page = 1

onready var SCREEN_SIZE = get_viewport_rect().size


##############################
# Tutorial Texts
##############################
var tutorial_texts = [
    "Your goal is to get from the start (the blue hex) to the end (the green hex) by making a path.",
    "The small read dots in the endges emits invisible 'lasers' - painted here to make it easier to see - in a straight line from each edge they tough. Your path can only go through hexes where there are no lasers, or an even number crosses (2,4,6, etc)!",
    "You can make a path by clicking on a hex next to a place you have already marked a hex, starting at the start. You can also remove the last hex you marked by clicking it again. Try to find a way to the end!",
    "When you have made a path to the end, and click the end(!), the game will let you know if you found the way. The red are forbidden hexes, orange are forbidden hexes you marked and lightgreen/yellow are hexes you were allowed to mark. If you got no orange ones, you won! Have fun!!!"
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
    $CenterContainer/VBoxContainer/PlayButton.connect("button_down", self, "play")
    $CenterContainer/VBoxContainer/DifficultyButton.connect("button_down", self, "change_difficulty")
    $CenterContainer/VBoxContainer/SizeButton.connect("button_down", self, "change_size")
    $CenterContainer/VBoxContainer/QuitButton.connect("button_down", self, "quit")
    
    $GameBtnContainer/RestartButton.connect("button_down", self, "restart")
    $GameBtnContainer/QuitButton.connect("button_down", self, "quit_game")
    
    $CenterContainer/VBoxContainer/TutorialButton.connect("button_down", self, "tutorial")
    
    $Tutorial/NextButton.connect("button_down", self, "tutorial_next")
    $Tutorial/CancelButton.connect("button_down", self, "tutorial_cancel")


func play():
    $BackHexSprite.hide()
    $BackHexSprite2.hide()
    $CenterContainer.hide()
    $Tutorial.hide()
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
    
func tutorial():
    $BackHexSprite.hide()
    $BackHexSprite2.hide()
    $CenterContainer.hide()
    
    $Tutorial.show()
    
    $Tutorial/TutPic.texture = load("Art/tut_bilde1.png" )
    $Tutorial/Tutorial_Label.text = tutorial_texts[0]
    
    
func tutorial_cancel():
    $BackHexSprite.show()
    $BackHexSprite2.show()
    $CenterContainer.show()
    
    $Tutorial.hide()
    
    
func tutorial_next():
    tutoral_page = tutoral_page + 1
    
    if tutoral_page > 4:
        tutoral_page = 1
        tutorial_cancel()
    else:
        $Tutorial/TutPic.texture = load("Art/tut_bilde%s.png" %tutoral_page)
        $Tutorial/Tutorial_Label.text = tutorial_texts[tutoral_page-1]
        
    
    
    
    
