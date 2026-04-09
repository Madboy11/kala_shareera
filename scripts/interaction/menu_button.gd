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
	if SceneManager != null:
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
			"exit":
				get_tree().quit()
