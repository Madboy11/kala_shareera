extends Node3D

func _ready() -> void:
	var platform = OS.get_name()
	
	if platform == "Windows" or platform == "macOS" or platform == "Linux":
		print("Universal Rig: Desktop OS Detected! Booting Desktop Rig.")
		var xr_interface = XRServer.find_interface("OpenXR")
		if xr_interface and xr_interface.is_initialized():
			print("Universal Rig: Shutting down OpenXR hooks for desktop mode.")
			xr_interface.uninitialize()
		get_tree().root.use_xr = false
		_spawn_rig("res://scenes/player/desktop_camera_rig.tscn")
	elif platform == "Android":
		# Check if the OpenXR plugin successfully booted VR hooks
		var xr_interface = XRServer.find_interface("OpenXR")
		if xr_interface and xr_interface.is_initialized():
			print("Universal Rig: Detected OpenXR! Booting Quest Rig.")
			_spawn_rig("res://scenes/player/quest_camera_rig.tscn")
		else:
			print("Universal Rig: OpenXR failed or not present. Booting Mobile Gyro Rig.")
			_spawn_rig("res://scenes/player/vr_camera_rig.tscn")
	else:
		# Fallback to desktop for anything else
		_spawn_rig("res://scenes/player/desktop_camera_rig.tscn")

func _spawn_rig(path: String) -> void:
	var rig_scene = load(path)
	if rig_scene:
		var instance = rig_scene.instantiate()
		add_child(instance)
	else:
		push_error("Universal Rig: Failed to load rig at ", path)
