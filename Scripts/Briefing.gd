extends Control

@onready var animation_player = $AnimationPlayer
@onready var game: Node2D

@onready var panel_01 = $Control/Container/Panel01

@onready var panel_02 = $Control/Container/Panel02
@onready var panel_025 = $Control/Container/Panel025

@onready var panel_03 = $Control/Container/Panel03
@onready var panel_04 = $Control/Container/Panel04


var panels: Array = []  # Add your panel sprites here
var currentPanelIndex: int = 0
@onready var avancar = $Control/Container/Avancar


func _ready():
	avancar.hide()
	game = get_tree().get_first_node_in_group("game")
	
	
	## Add story panesls
	panels.append(panel_01)
	panels.append(panel_025)
	panels.append(panel_02)

	panels.append(panel_03)
	panels.append(panel_04)
	# Show the initial panel
	showPanel(currentPanelIndex)
	
func showPanel(index: int):
	for i in range(panels.size()):
		panels[i].visible = (i == index)



func _process(delta):
	if currentPanelIndex == 4:
		avancar.show()


func _on_avancar_pressed():
	game.change_state(game.States.LOADING)
	
func _on_flip_back_pressed():
	if currentPanelIndex == 1:
		animation_player.play_backwards("BookPageFlip")
	
	currentPanelIndex -= 1
	if currentPanelIndex < 0:
		currentPanelIndex = panels.size() - 1  # Wrap around to last panel
	showPanel(currentPanelIndex)


func _on_flip_forward_pressed():
	animation_player.play("BookPageFlip")
	
	currentPanelIndex += 1
	currentPanelIndex %= panels.size()
	#if currentPanelIndex < 0:
		#currentPanelIndex = panels.size() - 1
	showPanel(currentPanelIndex)
