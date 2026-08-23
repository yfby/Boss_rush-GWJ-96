class_name TaskDisplay
extends Control

@onready var task_label: RichTextLabel = $Panel/MarginContainer/RichTextLabel

func task(new_task: String) -> void:
	task_label.text = new_task
