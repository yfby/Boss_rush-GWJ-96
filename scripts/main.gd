extends Node

const DEATH_SCREEN = preload("res://scenes/ui/death_screen.tscn")

var death_screen: bool = false
var death_ui: DeathScreen = null

enum CURRENT_LEVEL {
	TUTORIAL,
	WORM_LEVEL,
	ROBOT_LEVEL
}

var progress: CURRENT_LEVEL

# Load new scene
func _ready() -> void:
	load_robot_level()

func load_tutorial() -> void:
	progress = CURRENT_LEVEL.TUTORIAL
	SceneManager.change_scene("res://scenes/levels/tutorial.tscn")
	await SceneManager.level_loaded
	SceneManager.current_level.player_died.connect(_death_screen)
	SceneManager.current_level.level_finished.connect(load_worm_level)

func load_worm_level() -> void:
	progress = CURRENT_LEVEL.WORM_LEVEL
	SceneManager.change_scene("res://scenes/levels/WormBossLevel.tscn")
	await SceneManager.level_loaded
	SceneManager.current_level.player_died.connect(_death_screen)
	SceneManager.current_level.level_finished.connect(load_robot_level)

func load_robot_level() -> void:
	progress = CURRENT_LEVEL.ROBOT_LEVEL
	SceneManager.change_scene("res://scenes/levels/RobotBossLevel.tscn")
	await SceneManager.level_loaded
	SceneManager.current_level.player_died.connect(_death_screen)
	#SceneManager.current_level.level_finished.connect(load_worm_level) # win screen

func _death_screen() -> void:
	if death_screen == true:
		return
	
	# Pause the whole scene
	SceneManager.current_level.process_mode = Node.PROCESS_MODE_DISABLED
	
	death_ui = DEATH_SCREEN.instantiate()
	
	%SystemUI.add_child(death_ui)
	
	await get_tree().process_frame
	
	death_ui.start_death_screen()
	death_ui.respawn.connect(_respawn)
	
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.DEATH_SCREEN,0.5)
	
	death_screen = true

func _respawn() -> void:
	match progress:
		CURRENT_LEVEL.TUTORIAL:
			load_tutorial()
		CURRENT_LEVEL.WORM_LEVEL:
			load_worm_level()
		CURRENT_LEVEL.ROBOT_LEVEL:
			load_robot_level()
	death_screen = false
	death_ui.queue_free()
