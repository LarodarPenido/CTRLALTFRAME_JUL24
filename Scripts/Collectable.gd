extends Area2D

@export var item_types = {
	"ship_fuel": {"sprite": preload("res://Assets/Sprites/Collectibles/ship_fuel.png"), "sound": preload("res://Assets/Sounds/pickup.mp3")},
	"catnip": {"sprite": preload("res://Assets/Sprites/Collectibles/catnip.png"), "sound": preload("res://Assets/Sounds/pickup.mp3")},
	"red_mineral": {"sprite": preload("res://Assets/Sprites/Collectibles/red_mineral.png"), "sound": preload("res://Assets/Sounds/pickup.mp3")},
	"star": {"sprite": preload("res://Assets/Sprites/Collectibles/star.png"), "sound": preload("res://Assets/Sounds/pickup.mp3")},
	"book": {"sprite": preload("res://Assets/Sprites/Collectibles/book.png"), "sound": preload("res://Assets/Sounds/pickup.mp3")}
}

@export var item_sprite: Sprite2D
@export var item_pick_sound: AudioStreamPlayer2D
@onready var clear_timer = $ClearTimer

var can_play = true

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	if body is Player:
		if can_play:
			item_pick_sound.play()
		can_play = false
		hide()
		## deduct from stack TODO
		## add progress to fuel/wand upgrade / star fragment TODO
		clear_timer.start()

func _on_clear_timer_timeout():
	queue_free()

func set_item_type(item_type):
	if item_type in item_types:
		item_sprite.texture = item_types[item_type]["sprite"]
		item_pick_sound.stream = item_types[item_type]["sound"]


#extends Area2D
#
#### igid bodies launched up on ready?
#
### audio
#
#@onready var item_pick_sound = $AudioStreamPlayer2D
#
#@onready var clear_timer = $ClearTimer
#
#var can_play = true
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
#func _on_body_entered(body):
	#if body is Player:
		#if can_play:
			#item_pick_sound.play()
		#can_play = false
		#hide()
		### deduct from stack TODO
		### add progress to fuel/wand upgrade / star fragment TODO
		#clear_timer.start()
		#
		#
#
#
#func _on_clear_timer_timeout():
	#queue_free()
