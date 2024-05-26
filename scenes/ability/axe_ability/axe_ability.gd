extends Node2D

@onready var hitbox_component = $HitboxComponent
var base_rotation = Vector2.RIGHT
const MAX_RADIUS: int = 100

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	var duration = 2.8
	var to = 0.0
	tween.tween_method(tween_method, to, 2.0, duration)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var percent = rotations / 2
	var current_direction = base_rotation.rotated(rotations * TAU)
	var current_radius = percent * MAX_RADIUS
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null): return
	global_position = player.global_position + (current_direction * current_radius)
