extends Node2D

## this file was to test if maaacks level_lost system works for us
signal level_lost

@export var level_boss: Boss

@onready var dialog_box: DialogBox = %DialogBox

@onready var player: Player = %Player

var sucked_up_some_minions: bool = false
var tried_shooting: bool = false

var tutorial_done: bool = false

#@export var boss_music 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.gun.able_to_shoot = false
	player.gun.able_to_vacuum = false
	EventBus.player_died.connect(_on_player_died)
	AudioManager.stop_all_music(2)
	
	await get_tree().create_timer(2.5).timeout
	dialog_box.start_dialogue([
		{"name": "Static", "text": "uhh...?"},
		{"name": "You", "text": "What???!?."},
		{"name": "Static", "text": "??."},
		{"name": "You", "text": "Where... am I? Why does the ground look like burnt toast?"},
		{"name": "Static", "text": "Oh good, you're awake. I was starting to think I dragged a corpse out here for nothing."},
		{"name": "You", "text": "Who said that?! Show yourself!"},
		{"name": "Static", "text": "I would, but that's not really how this works."},
		{"name": "You", "text": "...I'm looking directly at where the voice is coming from and there is NOTHING there."},
		{"name": "Static", "text": "Yeah, that tracks. You get used to it."},
		{"name": "You", "text": "I will NOT be getting used to it."},
		{"name": "Static", "text": "That's what the last guy said too."},
		{"name": "You", "text": "...the last guy?"},
		{"name": "Static", "text": "Different story! Anyway, congrats on the amnesia. Very trendy. Very mysterious-protagonist energy."},
		{"name": "You", "text": "I don't even know my own name, and now I'm being haunted."},
		{"name": "Static", "text": "I prefer 'guided.' Haunted implies I have bad intentions."},
		{"name": "You", "text": "Do you?"},
		{"name": "Static", "text": "I mean, define 'bad.'"},
		{"name": "You", "text": "That is not the response of an innocent voice."},
		{"name": "Static", "text": "Moving on! Wait, what's THIS thing stuck to my arm?"},
		{"name": "You", "text": "That was MY line, I was about to say that."},
		{"name": "Static", "text": "I know, I got excited. Give me a second, I'll walk you through it."},
		{"name": "Static", "text": "That's a cannon. Also a vacuum. Don't overthink it."},
		{"name": "You", "text": "How does something be both of those things."},
		{"name": "Static", "text": "Badly, mostly. But it works. Trigger once, it sucks stuff in. Trigger again, it shoots stuff out."},
		{"name": "You", "text": "So it's a straw."},
		{"name": "Static", "text": "It is not a straw."},
		{"name": "You", "text": "It's a violent straw."},
		{"name": "Static", "text": "It's an ARTIFACT OF ANCIENT POWER, but sure, 'straw' works too, whatever helps you sleep."},
		{"name": "You", "text": "Sucks WHAT in, exactly?"},
		{"name": "Static", "text": "Oh, see that little glowing thing floating by the rocks? Try it on that."},
		{"name": "You", "text": "That's... a tiny glowing thing. It looks like it's judging me."},
		{"name": "Static", "text": "That's an Elemental. Cute little guys, aren't they? Fire, ice, lightning, that sort of thing. Wander around like lost puppies."},
		{"name": "You", "text": "Can I pet it?"},
		{"name": "Static", "text": "You can suck it into your cannon, which is basically the same thing. Emotionally."},
		{"name": "You", "text": "That feels ethically questionable."},
		{"name": "Static", "text": "It's a GRAY AREA, not a crime scene. Point, trigger, done. I believe in you, disembodied-voice's-honor."},
		{"name": "You", "text": "That is not a real thing you can swear on."},
		{"name": "Static", "text": "It's the only thing I've got, work with me here. Now try it."}
	])
	#dialog_box._advance()
	

func _on_player_died() -> void:
	AudioManager.stop_all_music(2)
	AudioManager.play_music(MusicTrack.TRACK_TYPE.DEATH_SCREEN,0.5)
	#AudioManager.get_managed_player("death_music_player").play()
	level_lost.emit()
