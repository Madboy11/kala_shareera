extends Node

signal scene_loading(scene_name: String)
signal scene_loaded(scene_name: String)

var scenes = {
	"menu": "res://scenes/menu/main_menu.tscn",
	"intro": "res://scenes/modules/intro_module.tscn",
	"mamsadhara": "res://scenes/modules/mamsadhara_module.tscn",
	"raktadhara": "res://scenes/modules/raktadhara_module.tscn",
	"medodhara": "res://scenes/modules/medodhara_module.tscn",
}

var current_scene: String = ""
var previous_scene: String = ""

func load_scene(scene_name: String):
	if not scenes.has(scene_name):
		push_error("Scene not found: " + scene_name)
		return
	
	emit_signal("scene_loading", scene_name)
	
	previous_scene = current_scene
	current_scene = scene_name
	
	# Show loading screen
	if UIManager != null:
		UIManager.show_loading()
	
	var error = get_tree().change_scene_to_file(scenes[scene_name])
	if error != OK:
		push_error("Failed to change scene")
	
	emit_signal("scene_loaded", scene_name)
	
	if UIManager != null:
		UIManager.hide_loading()

func load_module(module_name: String):
	load_scene(module_name)

func return_to_menu():
	load_scene("menu")

func return_to_previous():
	if previous_scene != "":
		load_scene(previous_scene)
	else:
		return_to_menu()
