extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D

@export var max_bounces := 100
@export var max_distance: float = 1000.0
@export var laser_active: bool = true
@export var default_direction := Vector2(1, 0.2)

func _physics_process(_delta: float) -> void:
	if not laser_active:
		return

	var start_point := global_position
	var direction := default_direction
	var current_points := [start_point]
	
	for i in range(max_bounces):
		ray_cast_2d.global_position = current_points[-1]
		var end_point = start_point + direction * max_distance
		ray_cast_2d.target_position = to_local(end_point)
		ray_cast_2d.force_raycast_update()

		if ray_cast_2d.is_colliding():
			var collision_point = ray_cast_2d.get_collision_point()
			var collision_normal = ray_cast_2d.get_collision_normal()
			var collider = ray_cast_2d.get_collider()

			current_points.append(collision_point)

			if collider.is_in_group("reflect_object"):
				direction = direction.bounce(collision_normal).normalized()
			else:
				break
		else:
			current_points.append(end_point)
			break

	line_2d.clear_points()
	for point in current_points:
		line_2d.add_point(to_local(point))
