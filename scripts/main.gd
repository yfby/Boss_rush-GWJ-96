extends Node

# Load new scene
func _ready() -> void:
	load_tutorial()

func load_tutorial() -> void:
	SceneManager.change_scene("res://scenes/levels/tutorial.tscn")
	await SceneManager.level_loaded
	SceneManager.current_level.level_finished.connect(_load_worm_level)

func _load_worm_level() -> void:
	SceneManager.change_scene("res://scenes/levels/WormBossLevel.tscn")
