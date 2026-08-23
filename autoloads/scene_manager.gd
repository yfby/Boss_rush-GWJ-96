extends Node

signal level_loaded

var current_level: Node = null
var current_path: String = ""
var is_changing_scene: bool = false

#var loading_screen_scene = preload("res://ui/loading_screen.tscn")

func change_scene(path: String) -> void:
	if is_changing_scene:
		push_warning("SceneManager: change_scene ignored, already changing scene.")
		return
	current_path = path
	call_deferred("_deferred_change_scene", path)


func restart_scence() -> void:
	if current_path == "":
		push_warning("SceneManager: no current_path set, can't restart.")
		return
	if is_changing_scene:
		push_warning("SceneManager: restart ignored, already changing scene.")
		return
	call_deferred("_deferred_change_scene", current_path)


func _deferred_change_scene(path: String) -> void:
	is_changing_scene = true
	# TODO: INSTANTIATE LOADING SCREEN HERE

	if is_instance_valid(current_level):
		var old_level := current_level
		current_level = null  # clear immediately so nothing grabs a stale ref mid-await
		old_level.queue_free()
		await old_level.tree_exited

	var packed_scene: PackedScene = load(path)
	if packed_scene == null:
		push_error("SceneManager: failed to load scene at path: %s" % path)
		is_changing_scene = false
		return

	var new_scene: Node = packed_scene.instantiate()

	# Add to root tree safely
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_level = new_scene

	# Correctly wait for the new scene setup to finish
	await get_tree().process_frame

	print("Level ready")
	level_loaded.emit()
	is_changing_scene = false

	# TODO: FREE LOADING SCREEN HERE
