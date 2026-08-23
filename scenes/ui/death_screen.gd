class_name DeathScreen
extends Control

signal dialogue_finished
signal respawn

@export var death_message: String = "YOU DIED"
@export var fade_duration: float = 1.0
@export var char_speed: float = 0.05

@onready var death_label: Label = $Label

var can_spawn: bool = false
var spawned: bool = false

func _ready() -> void:
	modulate.a = 0.0
	hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and can_spawn and not spawned:
		spawned = true
		fade_out()
		
		respawn.emit()


func start_death_screen() -> void:
	show()
	modulate.a = 0.0
	%Respawn.modulate.a = 0.0
	death_label.text = ""

	var fade_in := create_tween()
	fade_in.tween_property(self, "modulate:a", 1.0, fade_duration)
	await fade_in.finished

	await _type_message()
	
	var respawn_tween := create_tween()
	respawn_tween.tween_property(%Respawn, "modulate:a", 1.0, 1.5)
	await respawn_tween.finished
	
	can_spawn = true


func _type_message() -> void:
	var full_text := death_message
	death_label.text = ""
	
	AudioManager.play_audio(SoundEffect.SOUND_EFFECT_TYPE.DIALOG)
	
	for i in full_text.length():
		death_label.text += full_text[i]
		await get_tree().create_timer(char_speed).timeout


func fade_out() -> void:
	var respawn_fade := create_tween()
	respawn_fade.tween_property(%Respawn, "modulate:a", 0.0, 0.4)
	await respawn_fade.finished

	var screen_fade := create_tween()
	screen_fade.tween_property(self, "modulate:a", 0.0, fade_duration)
	await screen_fade.finished

	dialogue_finished.emit()

	queue_free()
