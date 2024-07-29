extends Node2D

@onready var rock_hit = $RockSounds/RockHit
@onready var rock_break = $RockSounds/RockBreak

@onready var player_float = $PlayerSounds/PlayerFloat
@onready var player_fire = $PlayerSounds/PlayerFire
@onready var player_catnip = $PlayerSounds/PlayerCatnip
@onready var player_hurt = $PlayerSounds/PlayerHurt
@onready var player_die = $PlayerSounds/PlayerDie

@onready var spell_cast = $PlayerSounds/SpellCast
@onready var spell_hit = $PlayerSounds/SpellHit

@onready var ghost_sleep = $Enemies/GhostSleep
@onready var ghost_haunt = $Enemies/GhostHaunt
@onready var ghost_stun = $Enemies/GhostStun
@onready var ghost_banished = $Enemies/GhostBanished
@onready var ghost_game_over = $Enemies/GhostGameOver

@export var music: AudioStreamPlayer
@export var catnip_music: AudioStreamPlayer


@onready var spell: Node2D

func _ready():
	
	play_music()

func play_music():
	if music and catnip_music:
		if catnip_music.is_playing:
			catnip_music.stop()
			music.play()
			#print("music should be playing")
		else:
			music.play()
			#print("music should be playing")

func play_catnip_music():
	if music and catnip_music:
		if music.is_playing:
			music.stop()
			catnip_music.play()
			#print("music should be playing")
		else:
			catnip_music.play()
			#print("music should be playing")

func _on_spell_hit():
		spell_hit.play()


func play_rock_break():
	rock_break.play()

func play_haunt():
	ghost_haunt.play()
func play_banished():
	ghost_banished.play()
func play_stun():
	ghost_stun.play()
func play_sleep():
	ghost_sleep.play()

func play_player_hit():
	player_hurt.play()
func play_player_catnip():
	player_catnip.play()
func play_player_die():
	player_die.play()
func play_player_float():
	player_float.play()
func play_player_fire():
	player_fire.play()


func play_gameover():
	ghost_game_over.play()
	
func stop_gameover():
	ghost_game_over.stop()
