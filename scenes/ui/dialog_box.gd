class_name DialogBox
extends Control

signal dialogue_finished

@onready var name_label: Label = $Panel/NameLabel
@onready var dialogue_label: RichTextLabel = $Panel/MarginContainer/DialogueLabel

var lines: Array = []
var current_line: int = 0
var is_typing: bool = false
var char_speed: float = 0.02

func _ready() -> void:
	hide()
	dialogue_label.bbcode_enabled = true

func start_dialogue(dialogue_lines: Array) -> void:
	lines = dialogue_lines
	current_line = 0
	show()
	_show_line(current_line)

func _show_line(index: int) -> void:
	var entry = lines[index]
	name_label.text = entry.get("name", "")
	dialogue_label.text = ""
	is_typing = true
	var full_text: String = entry["text"]
	for i in full_text.length():
		if not is_typing:
			dialogue_label.text = full_text
			break
		dialogue_label.text += full_text[i]
		await get_tree().create_timer(char_speed).timeout
	is_typing = false

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			is_typing = false  # skip typewriter, show full line instantly
		else:
			_advance()

func _advance() -> void:
	current_line += 1
	if current_line >= lines.size():
		hide()
		dialogue_finished.emit()
	else:
		_show_line(current_line)
