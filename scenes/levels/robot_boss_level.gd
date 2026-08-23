extends Node2D

## this file was to test if maaacks level_lost system works for us
signal player_died
signal level_finished

const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")

@onready var player: Player = %Player

@onready var ui_layer: CanvasLayer

var current_dialog: DialogBox = null
var complete: bool = false


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
	if complete == true:
		return
	
	complete = true
	print("robot died")
	
	await get_tree().create_timer(1.0).timeout
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "You", "text": "...it's down."},
		{"name": "Static", "text": "It's down. You're standing. I don't— I don't actually have a joke for this one."},
		{"name": "You", "text": "First time for everything."},
		{"name": "Static", "text": "Yeah."},
		{"name": "You", "text": "Are you going to tell me what's actually going on now?"},
		{"name": "Static", "text": "...eventually. Not today. Today you did enough."},
		{"name": "You", "text": "That's not an answer either."},
		{"name": "Static", "text": "No. It isn't. But you're alive, the worm's gone, the robot's gone, and I'm still here."},
		{"name": "You", "text": "Vaguely."},
		{"name": "Static", "text": "Vaguely. Always vaguely."},
		{"name": "You", "text": "...thanks. For, whatever this was."},
		{"name": "Static", "text": "Don't thank me yet. Rest up. Next time I'll actually have a plan."},
		{"name": "You", "text": "Promise?"},
		{"name": "Static", "text": "...probably."}
	])
	current_dialog.dialogue_finished.connect(end)

func end() -> void:
	await get_tree().create_timer(2.5).timeout
	level_finished.emit()

func _on_player_died() -> void:
	ui_layer.queue_free()
	player_died.emit()
