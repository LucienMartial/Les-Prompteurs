extends Node2D

@export var directions: Array = [
	Vector2(0, 1),   # Haut
	Vector2(1, 1),   # Haut Droite
	Vector2(1, 0),   # Droite
	Vector2(1, -1),   # Droite Bas
	Vector2(0, -1),   # Bas
	Vector2(-1, -1),   # Bas Gauche
	Vector2(-1, 0),  # Gauche
	Vector2(-1, 1),  # Gauche Haut
]

@export var laser_length: float = 922337203.0  # Longueur maximale du laser

const DEFAULT_DIRECTION_INDEX: int = 0

func _ready():
	position = Vector2(80, 250)
	update_raycast_direction(DEFAULT_DIRECTION_INDEX)
	var control = $Control
	ray_cast_2d = $RayCast2D
	line_2d = $Line2D
	control.connect("direction_changed", Callable(self, "_on_direction_changed"))

	var sprite = $Sprite2D
	sprite.connect("position_dragged", Callable(self, "_on_position_dragged"))

func _on_position_dragged(new_position):
	global_position = new_position
	laser_active = true

func update_raycast_direction(direction_index: int):
	# Met à jour la direction en fonction de l'index actuel
	var raycast = $RayCast2D
	var direction = directions[direction_index]
	raycast.target_position = direction.normalized() * laser_length

@onready var ray_cast_2d: RayCast2D
@onready var line_2d: Line2D

@export var max_bounces := 100
@export var max_distance: float = 1000.0
@export var laser_active: bool = true

func _physics_process(_delta: float) -> void:
	if not laser_active:
		return

	var start_point := global_position
	var direction := ray_cast_2d.target_position
	var current_points := [start_point]

	for i in range(max_bounces):
		ray_cast_2d.global_position = current_points[-1]
		var end_point = start_point + direction * max_distance
		#ray_cast_2d.target_position = to_local(end_point)
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

	laser_active = false
