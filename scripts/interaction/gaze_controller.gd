extends Node

signal target_focused(target: Node3D)
signal target_unfocused()
signal interaction_triggered(target: Node3D)

@export var dwell_time: float = 2.0  # Seconds
@export var raycast: RayCast3D

var current_target: Node3D = null
var hover_time: float = 0.0
var is_hovering: bool = false
var crosshair: MeshInstance3D

func _ready():
	# Create a true 3D Crosshair for VR
	crosshair = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 0.03
	sphere.height = 0.06
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.2, 0.2) # Red Crosshair
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.no_depth_test = true # So it always draws on top of objects
	sphere.surface_set_material(0, mat)
	crosshair.mesh = sphere
	crosshair.top_level = true # Disconnect transform from parent
	add_child(crosshair)

func _process(delta):
	# Update crosshair position
	if crosshair and raycast:
		if raycast.is_colliding():
			crosshair.global_position = raycast.get_collision_point()
		else:
			# Float the crosshair 3 meters in front if not hitting anything
			crosshair.global_position = raycast.global_position + (-raycast.global_transform.basis.z * 3.0)

	if not raycast or not raycast.is_colliding():
		reset_hover()
		return
	
	var hit = raycast.get_collider()
	
	# Check if valid interactive object
	if not hit.has_method("on_gaze_interact"):
		reset_hover()
		return
	
	# New target detected
	if current_target != hit:
		reset_hover()
		current_target = hit
		emit_signal("target_focused", current_target)
		if current_target.has_method("on_gaze_enter"):
			current_target.on_gaze_enter()
		is_hovering = true
	
	# Accumulate dwell time
	if is_hovering:
		hover_time += delta
		
		# Update reticle progress
		var progress = hover_time / dwell_time
		if ReticleManager:
			ReticleManager.set_progress(progress)
		
		# Trigger interaction
		if hover_time >= dwell_time:
			trigger_interaction()

func trigger_interaction():
	if current_target and current_target.has_method("on_gaze_interact"):
		current_target.on_gaze_interact()
		emit_signal("interaction_triggered", current_target)
		
	reset_hover()

func reset_hover():
	if current_target:
		if current_target.has_method("on_gaze_exit"):
			current_target.on_gaze_exit()
		emit_signal("target_unfocused")
	
	current_target = null
	hover_time = 0.0
	is_hovering = false
	if ReticleManager:
		ReticleManager.set_progress(0.0)
