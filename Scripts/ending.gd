extends Control

@onready var game: Node2D

@onready var panel_01 = $TextureRect
@onready var panel_02 = $TextureRect2

var panels: Array = []  # Add your panel sprites here
var currentPanelIndex: int = 0

@onready var sair = $QuitButton

func _ready():
	sair.hide()
	game = get_tree().get_first_node_in_group("game")
	
	## Add story panesls
	panels.append(panel_01)
	panels.append(panel_02)
	# Show the initial panel
	showPanel(currentPanelIndex)
	
func showPanel(index: int):
	for i in range(panels.size()):
		panels[i].visible = (i == index)

func _process(delta):
	if currentPanelIndex == 1:
		sair.show()

func _on_quit_button_pressed():
	game.change_state(game.States.MAINMENU)

func _on_back_pressed():
	currentPanelIndex -= 1
	if currentPanelIndex < 0:
		currentPanelIndex = panels.size() - 1  # Wrap around to last panel
	showPanel(currentPanelIndex)


func _on_forward_pressed():
	currentPanelIndex += 1
	currentPanelIndex %= panels.size()
	showPanel(currentPanelIndex)
