extends Node

signal level_loaded

var current_level: Node = null
#var loading_screen_scene = preload("res://ui/loading_screen.tscn")
var current_path: String # for checking, and restarting scence logic

func change_scene(path: String) -> void:
	call_deferred("_deferred_change_scene", path)
	current_path = path

func restart_scence() -> void:
	# FIX: Must use call_deferred here too to prevent thread-safety crashes
	call_deferred("_deferred_change_scene", current_path)

func _deferred_change_scene(path: String) -> void:
	# TODO: INSTANTIATE LOADING SCREEN HERE
	
	if current_level:
		var old_level = current_level
		old_level.queue_free()
		# FIX: Wait until the old scene is fully removed from memory
		await old_level.tree_exited 
		
	var new_scene: Node = load(path).instantiate()
	
	# Add to root tree safely
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_level = new_scene
	
	# Correctly wait for the new scene setup to finish
	# await new_child.ready # idk why this doesnt work?!!
	await get_tree().process_frame
	
	print("Level readyd")
	level_loaded.emit()
	
	# TODO: FREE LOADING SCREEN HERE
