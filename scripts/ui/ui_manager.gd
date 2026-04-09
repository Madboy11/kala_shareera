extends CanvasLayer

var fade_rect: ColorRect

func _ready():
	fade_rect = ColorRect.new()
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_rect.color = Color(0,0,0,0) # Start transparent so the screen is visible!
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # CRUCIAL: Stops UI from blocking swipes!
	add_child(fade_rect)

func show_loading():
	print("UI: Loading scene...")
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0,0,0,1), 0.5)

func hide_loading():
	print("UI: Finished loading")
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0,0,0,0), 0.5)

func show_completion_prompt():
	print("UI: Video complete. Returning to menu in 3 seconds...")
	var tween = create_tween()
	tween.tween_callback(func(): SceneManager.return_to_menu()).set_delay(3.0)
