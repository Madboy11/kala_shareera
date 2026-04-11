extends StaticBody3D
class_name InteractiveObject

@export_group("Interaction Settings")
@export var action_id: String = ""
@export var label_text: String = ""
@export_color_no_alpha var hover_color: Color = Color(0.3, 0.7, 1.0)

@export var main_icon: Texture2D

@onready var mesh: MeshInstance3D = $MeshInstance3D if has_node("MeshInstance3D") else null
@onready var label_3d: Label3D = $Label3D if has_node("Label3D") else null

var original_material: Material
var is_hovered: bool = false

func _ready():
	collision_layer = 2  # Interactive layer
	
	if mesh:
		# Create a dynamic standalone material for this button
		original_material = StandardMaterial3D.new()
		original_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		if main_icon:
			original_material.albedo_texture = main_icon
			original_material.emission_texture = main_icon # Ensure only the icon glows, not the quad
		original_material.albedo_color = Color(0.8, 0.8, 0.8) # Keep it visibly sleek
		original_material.roughness = 0.2 # Slight glossy glass feel
		
		# Add a subtle base emission
		original_material.emission_enabled = true
		original_material.emission = Color(0.4, 0.4, 0.45) # Visible soft glow
		original_material.emission_energy_multiplier = 1.2
		
		# Apply the material to the mesh
		mesh.set_surface_override_material(0, original_material)
	
	if label_text != "":
		if label_3d:
			label_3d.text = label_text
		else:
			# Auto-generate a Label3D if the user didn't add the node!
			var new_label = Label3D.new()
			new_label.text = label_text
			new_label.position.y = -0.65 # Move label down beneath the icon
			new_label.position.z = 0.1  # Float just barely in front
			new_label.font_size = 36
			# Premium font rendering
			var modern_font = SystemFont.new()
			modern_font.font_names = PackedStringArray(["Segoe UI", "Roboto", "Helvetica Neue", "Arial"])
			modern_font.font_weight = 700 # Bold typography
			new_label.font = modern_font
			new_label.outline_size = 2 # Subtle outline to prevent artifacts, not bold
			new_label.outline_render_priority = 0
			new_label.modulate = Color(1.0, 1.0, 1.0)
			add_child(new_label)

func on_gaze_enter():
	is_hovered = true
	if mesh and original_material and original_material is BaseMaterial3D:
		original_material.emission_enabled = true
		original_material.emission = hover_color
		original_material.emission_energy_multiplier = 4.0 # Strong glowing visual feedback
		# Switch texture if hover texture is provided
		if main_icon:
			original_material.albedo_color = Color(1.0, 1.0, 1.0)
	
	# Audio feedback
	if AudioManager != null:
		AudioManager.play_hover()
	
	# Scale feedback
	if mesh:
		var tween = create_tween()
		tween.tween_property(mesh, "scale", Vector3(1.05, 1.05, 1.05), 0.15).set_trans(Tween.TRANS_SINE)

func on_gaze_exit():
	is_hovered = false
	if mesh and original_material and original_material is BaseMaterial3D:
		# Revert to gentle base emission
		original_material.emission = Color(0.4, 0.4, 0.45)
		original_material.emission_energy_multiplier = 1.2
		if main_icon:
			original_material.albedo_color = Color(0.8, 0.8, 0.8)
	
	if mesh:
		var tween = create_tween()
		tween.tween_property(mesh, "scale", Vector3.ONE, 0.2).set_trans(Tween.TRANS_SINE)

func on_gaze_interact():
	# Audio feedback
	if AudioManager != null:
		AudioManager.play_click()
	# Override in derived classes
	print("Interacted with: ", action_id)
