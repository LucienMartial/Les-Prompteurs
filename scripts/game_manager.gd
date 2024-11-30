extends Node

const mirror : PackedScene = preload("res://scenes/reflect_object.tscn")
var objects = {}

const GRID_SIZE: int = 16

func handle_dropped_object(global_pos: Vector2):
	var snapped_pos = snap_to_grid(global_pos)
	
	if(str(snapped_pos) in objects):
		print("Case occupée")
		return
	
	var instance = mirror.instantiate()
	instance.position = snapped_pos
	get_parent().add_child(instance)
	objects[str(snapped_pos)] = instance

func snap_to_grid(position: Vector2):
	return Vector2(
		round(position.x / GRID_SIZE) * GRID_SIZE,
		round(position.y / GRID_SIZE) * GRID_SIZE
	)
