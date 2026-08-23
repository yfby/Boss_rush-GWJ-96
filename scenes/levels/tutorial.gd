extends Node2D

## this file was to test if maaacks level_lost system works for us
signal level_lost
signal level_finished

const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")
const TASK_DISPLAY = preload("res://scenes/ui/task_display.tscn")

@onready var player: Player = %Player

@onready var ui_layer: CanvasLayer = %UI

var sucked_up_some_minions: bool = false
var tried_shooting: bool = false

var current_dialog: DialogBox = null
var current_task: TaskDisplay = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.TUTORIAL_LEVEL, 2) #paly tutorial music
	
	EventBus.player_died.connect(_on_player_died)
	#EventBus.shot_fired.connect(_on_shot_fired)
	
	intro()

func _process(delta: float) -> void:
	if sucked_up_some_minions == false and player.gun.gun_storage.size() >= 3:
		sucked_up_some_minions = true
		tried_vacuuming()

func intro() -> void:
	player.gun.able_to_shoot = false
	player.gun.able_to_vacuum = false
	
	await get_tree().create_timer(2.5).timeout
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "Static", "text": "uhh...?"},
		{"name": "You", "text": "What???!?."},
		{"name": "Static", "text": "??."},
		{"name": "You", "text": "Where... am I? Why does the ground look like burnt toast?"},
		{"name": "Static", "text": "Oh good, you're awake. I was starting to think I dragged a corpse out here for nothing."},
		{"name": "You", "text": "Who said that?! Show yourself!"},
		{"name": "Static", "text": "I would, but that's not really how this works. You get used to it."},
		{"name": "You", "text": "I will NOT be getting used to it."},
		{"name": "Static", "text": "That's what the last guy said too. Anyway, congrats on the amnesia. Very mysterious-protagonist energy."},
		{"name": "You", "text": "Wait, what's THIS thing stuck to my arm?"},
		{"name": "Static", "text": "Oh, that! Two triggers. Right one's a vacuum, left one's a cannon."},
		{"name": "You", "text": "So it's a violent straw."},
		{"name": "Static", "text": "It's an ARTIFACT OF ANCIENT POWER, but sure, 'straw' works too."},
		{"name": "You", "text": "Suck WHAT up, exactly?"},
		{"name": "Static", "text": "See that glowing thing by the rocks? That's an Elemental. Cute little guys. Wander around like lost puppies."},
		{"name": "You", "text": "Can I pet it?"},
		{"name": "Static", "text": "You can vacuum it into your cannon, which is basically the same thing. Emotionally."},
		{"name": "You", "text": "That feels ethically questionable."},
		{"name": "Static", "text": "GRAY AREA, not a crime scene. Left trigger. Try it."}
	])
	current_dialog.dialogue_finished.connect(_intro_dialog_finished)

func _intro_dialog_finished() -> void:
	current_dialog.queue_free()
	
	current_task = TASK_DISPLAY.instantiate()
	ui_layer.add_child(current_task)
	
	current_task.task("Capture Elementals")
	player.gun.able_to_vacuum = true

func tried_vacuuming() -> void:
	current_task.queue_free()
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "You", "text": "...okay, it's in there. It's just floating in the little chamber thing looking betrayed."},
		{"name": "Static", "text": "Great! See, nobody died. Five stars, no notes."},
		{"name": "You", "text": "Can I keep it? As a pet? I'll call him Steve."},
		{"name": "Static", "text": "You can keep it as ammunition, which is the pet-adjacent option we offer."},
		{"name": "You", "text": "That's horrifying. Steve deserves better."},
		{"name": "Static", "text": "Steve will be fine. Steve is basically a bullet with feelings now."},
		{"name": "You", "text": "I don't like the sound of that."},
		{"name": "Static", "text": "You don't have to like it, you just have to trigger it. Go on, try shooting him out."}
	])
	current_dialog.dialogue_finished.connect(_vacuuming_dialog_finished)

func _vacuuming_dialog_finished() -> void:
	current_dialog.queue_free()
	
	current_task = TASK_DISPLAY.instantiate()
	ui_layer.add_child(current_task)
	
	current_task.task("Shoot the little guy out")
	
	EventBus.shot_fired.connect(on_shot_fired)
	player.gun.able_to_shoot = true

func on_shot_fired(shot_name: String) -> void:
	if tried_shooting == true:
		return
	
	current_task.queue_free()
	
	tried_shooting = true
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	
	current_dialog.start_dialogue([
		{"name": "You", "text": "I DID IT. Steve's gone. Steve's just... gone."},
		{"name": "Static", "text": "Steve's fine. Probably. Statistically speaking."},
		{"name": "You", "text": "This feels like a lot of responsibility for someone who woke up ten minutes ago."},
		{"name": "Static", "text": "Relax, you've got moves. \"Shift\" to dash, in case something out here wants you dead."},
		{"name": "You", "text": "Something out here wants me dead?"},
		{"name": "Static", "text": "Statistically speaking. Oh, and \"E\" to heal, if the dashing doesn't work out."},
		{"name": "You", "text": "That's very reassuring, thank you."},
		{"name": "Static", "text": "Don't mention it. Alright, that's the tour. Go on, get out there."},
		{"name": "You", "text": "Wait, where are YOU going?"},
		{"name": "Static", "text": "Nowhere! I'm always around. Somewhere. Vaguely. Anyway, good luck!"},
		{"name": "You", "text": "That's not an answer—"}
	])
	
	current_dialog.dialogue_finished.connect(_shooting_dialog_finished)

func _shooting_dialog_finished() -> void:
	current_dialog.queue_free()
	await get_tree().create_timer(5.0).timeout
	
	# tutorial done!
	level_finished.emit()

func _on_player_died() -> void:
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.DEATH_SCREEN,0.5)
	#AudioManager.get_managed_player("death_music_player").play()
	level_lost.emit()
