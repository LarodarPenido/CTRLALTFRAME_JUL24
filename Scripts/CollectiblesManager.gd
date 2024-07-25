extends Node2D

signal  tile_destroyed

@export var destructible_tile_id = 1
@export var collectable_scene = preload("res://Scenes/Collectable.tscn")
@export var break_particles_scene = preload("res://Scenes/break_particles.tscn")

@export var spawn_chance = 0.0

var total_items: int
var remaining_items: int

var total_initial_destructible_tiles = 0
var total_destructible_tiles = 0
var items_spawned = {
	"ship_fuel": 0,
	"catnip": 0,
	"red_mineral": 0,
	"star": 0,
	"book": 0
}

var required_items = {
	"ship_fuel": 10,
	"catnip": 3,
	"red_mineral": 5,
	"star": 1,
	"book": 1
}

## SFX tiles sounds




 


func _ready():
	count_total_destructible_tiles()
	total_items = count_items()
	remaining_items = count_items()

func count_total_destructible_tiles():
	total_destructible_tiles = 0
	total_initial_destructible_tiles = 0
	var tilemap = get_parent().get_node("TileMap")
	var used_rect = tilemap.get_used_rect()
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var map_position = Vector2(x, y)
			var tile_type_id = tilemap.get_cell_source_id(0, map_position)
			if tile_type_id == destructible_tile_id:
				var atlas_position = tilemap.get_cell_atlas_coords(0, map_position)
				if atlas_position.y == 0:
					total_destructible_tiles += 1
					total_initial_destructible_tiles += 1
	#print("Total destructible tiles:", total_destructible_tiles)

func count_items() -> int:
	var total_sum = 0
	for amount in required_items.values():
		total_sum += amount
	return total_sum


func handle_tile_destruction(map_position, collision_position):
	
	
	
	var tilemap = get_parent().get_node("TileMap")
	tilemap.erase_cell(0, map_position)
	total_destructible_tiles -= 1
	count_total_destructible_tiles()
	
	var spawn_chance = calc_spawn_chance()
	randomize()
	var spawn_roll = randf()
	#print("spawn roll: " + str(spawn_roll))
	#print("spawn chance: " + str(spawn_chance))
	if spawn_chance > spawn_roll:
		#print("spawn can happen")
		spawn_collectable(collision_position)
	else:
		pass
		#print("spawn cant happen")
	spawn_sparks(collision_position)


func spawn_collectable(_position):
	var spawn_item = choose_item_to_spawn()
	remaining_items = count_items()
	if spawn_item != "":

		var collectable = collectable_scene.instantiate()
		collectable.global_position = _position
		collectable.set_item_type(spawn_item)
		get_tree().root.add_child(collectable)
		
		
	else:
		pass
		#print("No item spawned at:", _position)

func choose_item_to_spawn():
	var keys = required_items.keys()
	if keys.size() == 0:
		return ""  # Return an empty string if there are no items left

	var random_index = randi() % keys.size()
	var random_key = keys[random_index]
	
	required_items[random_key] -= 1
	if required_items[random_key] <= 0:
		required_items.erase(random_key)
	print(random_key)
	return random_key
	
	
func calc_spawn_chance() -> float:
	if total_destructible_tiles <= 0:
		return 0.0
	var spawn_chance = float(remaining_items) / float(total_destructible_tiles)
	if spawn_chance > 1:
		spawn_chance = 1
	return spawn_chance

func spawn_sparks(_position):
	var sparks = break_particles_scene.instantiate()
	get_tree().root.add_child(sparks)
	sparks.global_position = _position
