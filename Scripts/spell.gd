extends CharacterBody2D

@export var spell_lifetime = 3.0
@export var spell_speed = 300.0
@onready var spell_direction: Vector2


@onready var life_timer = $LifeTimer

var direction: Vector2
var current_speed: Vector2

const DESTRUCTIBLE = 1

const COLLECTABLE = preload("res://Scenes/Collectable.tscn")

##VFX
## instantiate sparks on death

const BREAK_PARTICLES = preload("res://Scenes/break_particles.tscn")
func _ready():
	life_timer.start(spell_lifetime)
	current_speed = direction * spell_speed


func _physics_process(delta):

	velocity = current_speed * delta
	move_and_collide(velocity)
	
	var collision_info = move_and_collide(velocity)
	
	if collision_info:
		var _collider = collision_info.get_collider()
		print("Collision with:", _collider)
		var collider = collision_info.get_collider()
		if collider is TileMap:
			var collision_position = collision_info.get_position()
			print("Collision position:", collision_position)
			#var map_position = collider.local_to_map(collision_position)
			var map_position = collider.local_to_map(collision_position - collision_info.get_normal())
			print("Map position:", map_position)
			var tile_type_id = collider.get_cell_source_id(0, map_position)
			print("Tile type ID:", tile_type_id)
			if tile_type_id == DESTRUCTIBLE:
				var atlas_position = collider.get_cell_atlas_coords(0, map_position)
				print("Atlas position:", atlas_position)
				if atlas_position.y == 0:
					if atlas_position.x == 0:
						collider.erase_cell(0, map_position)
						spawn_collectable(collision_position)
						spawn_sparks(collision_position)
						# TODO
						# add chance system and collectible counter
						# play rock break sound
						# spawn particles
						# if chance, and collectable stack > 0, 
						# spawn collectable 
						# reduce collectable stack -= 1
					else:
						atlas_position.x -=1
						collider.set_cell(0, map_position, tile_type_id, atlas_position)
				
				queue_free()

func spawn_collectable(_position):
	print("Collectable spawned at:", _position)
	var collectable = COLLECTABLE.instantiate()
	get_tree().root.add_child(collectable)
	collectable.global_position = _position
	
func spawn_sparks(_position):
	var sparks = BREAK_PARTICLES.instantiate()
	get_tree().root.add_child(sparks)
	sparks.global_position = _position

func _on_life_timer_timeout():
	queue_free()
