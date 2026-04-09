extends XROrigin3D

var xr_interface: XRInterface

func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		# Turn off v-sync for VR to let the headset decide the framerate
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		# Tell our Godot viewport to render to the headset
		get_viewport().use_xr = true
	else:
		push_error("OpenXR not initialized, please check if your headset is connected and OpenXR is enabled in Project Settings.")
