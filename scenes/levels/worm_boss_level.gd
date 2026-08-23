extends Node2D

## this file was to test if maaacks level_lost system works for us
signal player_died
signal level_finished

const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")

const WORM_BOSS = preload("res://scenes/bosses/WormBossComplete.tscn")
const BOSS_HEALTH_BAR = preload("res://scenes/ui/worm_health_bar.tscn")

@onready var player: Player = %Player

@onready var ui_layer: CanvasLayer

var current_dialog: DialogBox = null

var earthquake: bool = false
var little_earthquake: bool = false

var current_boss: WormBoss
var boss_health_ui: BossHealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_layer = $UI
	
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.WORM_BOSS_P1, 2) #paly tutorial music
	
	EventBus.player_died.connect(_on_player_died)
	EventBus.boss_died.connect(worm_dead)
	#EventBus.shot_fired.connect(_on_shot_fired)
	
	got_teleported()

func _process(delta: float) -> void:
	if earthquake == true:
		player.camera.shake_continuous(1.0)
	if little_earthquake == true:
		player.camera.shake_continuous(0.4)

func got_teleported() -> void:
	little_earthquake = true
	await get_tree().create_timer(2.5).timeout
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "You", "text": "...where am I now?"},
		{"name": "Static", "text": "Give me a second, I'm still—"},
		{"name": "You", "text": "The ground's shaking again."},
		{"name": "Static", "text": "Yeah. I feel that too. Just stay calm and—"},
		{"name": "You", "text": "It's getting worse."},
		{"name": "Static", "text": "Okay, that's not— that's not good, that's—"},
	])
	
	current_dialog.dialogue_finished.connect(earthquake_again)

func earthquake_again() -> void:
	little_earthquake = false
	earthquake = true
	
	current_dialog.queue_free()
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "You", "text": "WHAT IS THAT?!"},
		{"name": "Static", "text": "That's a—"}
	])
	
	current_dialog.dialogue_finished.connect(giant_worm_spawns)

func giant_worm_spawns() -> void:
	earthquake = false
	
	current_boss = WORM_BOSS.instantiate()
	current_boss.position = %BossLocationSpawn.position
	%Boss.add_child(current_boss)
	
	boss_health_ui = BOSS_HEALTH_BAR.instantiate()
	ui_layer.add_child(boss_health_ui)

func worm_dead() -> void:
	print("worm is dead")
	#TODO
	pass

func _on_player_died() -> void:
	ui_layer.queue_free()
	player_died.emit()
