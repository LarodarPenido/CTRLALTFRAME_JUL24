extends Control

@onready var game: Node2D

@onready var panel_01 = $Control/Container/Panel01
@onready var panel_02 = $Control/Container/Panel02
@onready var panel_03 = $Control/Container/Panel03

var panels: Array = []  # Add your panel sprites here
var currentPanelIndex: int = 0

func _ready():
	game = get_tree().get_first_node_in_group("game")
	
	## Add story panesls
	panels.append(panel_01)
	panels.append(panel_02)
	panels.append(panel_03)
	# Show the initial panel
	showPanel(currentPanelIndex)
	
func showPanel(index: int):
	for i in range(panels.size()):
		panels[i].visible = (i == index)

func _process(delta):
	pass

func _on_avancar_pressed():
	game.change_state(game.States.LEVEL03)
	
func _on_flip_back_pressed():
	currentPanelIndex -= 1
	if currentPanelIndex < 0:
		currentPanelIndex = panels.size() - 1  # Wrap around to last panel
	showPanel(currentPanelIndex)

func _on_flip_forward_pressed():
	currentPanelIndex += 1
	currentPanelIndex %= panels.size()
	showPanel(currentPanelIndex)
