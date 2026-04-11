extends "res://scripts/interaction/interactive_object.gd"
class_name VRMenuButton

signal pressed(action_id: String)

func on_gaze_interact():
	super.on_gaze_interact()
	
	# Visual feedback
	if mesh:
		var tween = create_tween()
		tween.tween_property(mesh, "scale", Vector3(0.9, 0.9, 0.9), 0.1)
		tween.tween_property(mesh, "scale", Vector3.ONE, 0.1)
	
	# Emit signal
	emit_signal("pressed", action_id)
	
	# Handle action
	match action_id:
		"intro":
			SceneManager.load_module("intro")
		"mamsadhara":
			SceneManager.load_module("mamsadhara")
		"raktadhara":
			SceneManager.load_module("raktadhara")
		"medodhara":
			SceneManager.load_module("medodhara")
		"sleshmadhara":
			SceneManager.load_module("sleshmadhara")
		"purishadhara":
			SceneManager.load_module("purishadhara")
		"pittadhara":
			SceneManager.load_module("pittadhara")
		"shukradhara":
			SceneManager.load_module("shukradhara")
		"about":
			_show_about_panel()
		"exit":
			get_tree().quit()

func _show_about_panel():
	# Find or create the about panel in the scene
	var about = get_tree().get_first_node_in_group("about_panel")
	if about and about.has_method("show_panel"):
		about.show_panel()
	else:
		# Fallback: create a temporary about panel at the button's world position
		_create_inline_about()

func _create_inline_about():
	# Create a simple 3D about panel in front of the camera
	var panel = Node3D.new()
	panel.name = "AboutPanelTemp"
	get_tree().current_scene.add_child(panel)
	
	# Find camera position to place panel in front
	var cameras = get_tree().get_nodes_in_group("vr_camera")
	if cameras.size() > 0:
		panel.global_position = cameras[0].global_position + cameras[0].global_transform.basis.z * -2.0
		panel.look_at(cameras[0].global_position)
	else:
		panel.position = Vector3(0, 1, -2)
	
	# Create about text
	var label = Label3D.new()
	label.text = _get_about_text()
	label.font_size = 24
	label.width = 800
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.modulate = Color(0.95, 0.85, 0.5)  # Golden text
	label.outline_size = 3
	label.outline_modulate = Color(0.2, 0.1, 0.05)
	
	# Premium font
	var font = SystemFont.new()
	font.font_names = PackedStringArray(["Segoe UI", "Roboto", "Helvetica Neue", "Arial"])
	font.font_weight = 500
	label.font = font
	
	panel.add_child(label)
	
	# Create dark background panel behind text
	var bg_mesh = MeshInstance3D.new()
	var plane = PlaneMesh.new()
	plane.size = Vector2(2.5, 1.8)
	bg_mesh.mesh = plane
	bg_mesh.rotation_degrees = Vector3(90, 0, 0)
	bg_mesh.position.z = 0.05  # Slightly behind text
	
	var bg_mat = StandardMaterial3D.new()
	bg_mat.albedo_color = Color(0.03, 0.02, 0.06, 0.92)
	bg_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bg_mat.emission_enabled = true
	bg_mat.emission = Color(0.1, 0.05, 0.15)
	bg_mat.emission_energy_multiplier = 0.5
	bg_mesh.set_surface_override_material(0, bg_mat)
	panel.add_child(bg_mesh)
	
	# Auto-dismiss after 8 seconds with fade
	var tween = create_tween()
	tween.tween_interval(8.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_property(bg_mat, "albedo_color:a", 0.0, 0.5)
	tween.tween_callback(func(): panel.queue_free())

func _get_about_text() -> String:
	return """
╔══════════════════════════════════╗
        KALA SHAREERA VR
╚══════════════════════════════════╝

Ayurvedic Anatomy in Virtual Reality

Version 1.0.0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A VR educational experience exploring the
seven Kala (membranes) of the human body
as described in Ayurvedic Sharira Sthana.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Developed by: Vansh
Engine: Godot 4.5
Platform: Meta Quest / Android VR

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

© 2026 All Rights Reserved
"""
