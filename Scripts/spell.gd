extends CharacterBody2D


@onready var game: Node2D


@export var spell_lifetime = 3.0
@export var spell_speed = 200.0
@onready var spell_direction: Vector2
@onready var life_timer = $LifeTimer

signal spell_hit
signal enemy_hit

var direction: Vector2
var current_speed: Vector2

const DESTRUCTIBLE = 1
var collectibles_manager: Node2D

const COLLECTABLE = preload("res://Scenes/Collectable.tscn")
## VFX
const BREAK_PARTICLES = preload("res://Scenes/break_particles.tscn")


## SFX



func _ready():
	game = get_parent().get_node("Game")
	life_timer.start(spell_lifetime)
	current_speed = direction * spell_speed
	collectibles_manager = get_tree().get_first_node_in_group("CollectiblesManager") 

func _physics_process(delta):

	velocity = current_speed * delta
	move_and_collide(velocity)

	var collision_info = move_and_collide(velocity)
	
	if collision_info:
		spell_hit.emit()
		#var _collider = collision_info.get_collider()
		#print("Collision with:", _collider)
		var collider = collision_info.get_collider()
		
		if collider is Enemy:
			emit_signal("enemy_hit", collider)
			queue_free()

		if collider is TileMap:
			#print("hit a tile")
			var collision_position = collision_info.get_position()
			#print("Collision position:", collision_position)
			#var map_position = collider.local_to_map(collision_position)
			var map_position = collider.local_to_map(collision_position - collision_info.get_normal())
			#print("Map position:", map_position)
			var tile_type_id = collider.get_cell_source_id(0, map_position)
			#print("Tile type ID:", tile_type_id)
			if tile_type_id == DESTRUCTIBLE:
				var atlas_position = collider.get_cell_atlas_coords(0, map_position)
				#print("Atlas position:", atlas_position)
				if atlas_position.y == 0: ##Identify the destructible
					if atlas_position.x == 0:
						#var collectibles_manager = get_parent().get_node("CollectiblesManager")
						collectibles_manager.handle_tile_destruction(map_position, collision_position)
						queue_free()
						game.screen_shake(.001, .01)
					else:
						atlas_position.x -= 1
						collider.set_cell(0, map_position, tile_type_id, atlas_position)
			queue_free()

func _on_life_timer_timeout():
	queue_free()


