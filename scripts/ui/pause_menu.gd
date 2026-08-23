extends CanvasLayer
class_name PauseMenu


@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider




func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		if visible:
			get_tree().paused = true
		else:
			get_tree().paused = false
			
	

func _ready() -> void:
	visible = false


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_restart_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/tutorial.tscn")
	visible = false
	get_tree().paused = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()





func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
