extends Node2D

@export var game: Node2D

@onready var cooldown_timer = $CooldownTimer
@onready var can_shoot = true
@export var spell_cooldown = .5
@onready var wand_point = $WandPoint
@onready var wand_sprite = $WandSprite

const SPELL = preload("res://Scenes/spell.tscn")

##SFX
#@onready var spell_sound = $AudioStreamPlayer2D
@export var audio_manager: Node2D

##VFX
func _ready(): 
	pass

func _process(delta):
	if Input.is_action_pressed("fire"):
		cast_spell()

	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	if mouse_pos.x < global_position.x:
		wand_sprite.flip_v = true
	elif mouse_pos.x > global_position.x:
		wand_sprite.flip_v = false
		
	#if mouse_pos.y > global_position.y:
		#show_behind_parent = false
		#
	#elif mouse_pos.y < global_position.y:
	show_behind_parent = true

func cast_spell():
	if can_shoot:
		
		#game.screen_shake(.001, .01)
		var _spell = SPELL.instantiate()
		_spell.spell_hit.connect(audio_manager._on_spell_hit)

				# Connect the spell's enemy_hit signal to the wand's _on_enemy_hit method
		_spell.enemy_hit.connect(_on_enemy_hit)
		#_spell.enemy_hit.connect(_spell.collider._on_enemy_hit)

		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - wand_point.global_position).normalized()
		_spell.global_position = wand_point.global_position
		_spell.direction = direction
		get_tree().root.add_child(_spell)
		#spell_sound.play()
		can_shoot = false
		cooldown_timer.start(spell_cooldown)
		


func _on_cooldown_timer_timeout():
	can_shoot = true
	game.shake_reset()

func _on_enemy_hit(enemy):
	enemy._on_spell_hit()
