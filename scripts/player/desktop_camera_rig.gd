extends Node3D

@onready var camera = $Camera3D
var hovered_object: Node3D = null

func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 1000

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = 2 # Interactive layer
	
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		if hovered_object:
			if hovered_object.has_method("on_gaze_exit"):
				hovered_object.on_gaze_exit()
			hovered_object = null
	else:
		var hit = result.collider
		if hit != hovered_object:
			if hovered_object and hovered_object.has_method("on_gaze_exit"):
				hovered_object.on_gaze_exit()
			hovered_object = hit
			if hovered_object.has_method("on_gaze_enter"):
				hovered_object.on_gaze_enter()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if hovered_object and hovered_object.has_method("on_gaze_interact"):
			hovered_object.on_gaze_interact()
