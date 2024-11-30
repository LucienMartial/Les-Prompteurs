extends "res://scripts/laser.gd"

func _on_direction_changed(index):
	update_raycast_direction(index)
