extends Node2D

## this file was to test if maaacks level_lost system works for us
signal player_died
signal level_finished

const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")

@onready var player: Player = %Player

@onready var ui_layer: CanvasLayer

var current_dialog: DialogBox = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_layer = $UI
	
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.WORM_BOSS_P1, 2) #paly tutorial music
	
	EventBus.player_died.connect(_on_player_died)
	EventBus.boss_died.connect(robot_dead)
	#EventBus.shot_fired.connect(_on_shot_fired)
	
	# ALL THE DIALOGS

func robot_dead() -> void:
	print("robot died")
	#TODO
	pass

func _on_player_died() -> void:
	ui_layer.queue_free()
	player_died.emit()
