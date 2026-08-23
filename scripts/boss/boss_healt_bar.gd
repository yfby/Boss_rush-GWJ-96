class_name BossHealthBar
extends TextureProgressBar

func _ready() -> void:
	EventBus.boss_health_changed.connect(_on_boss_health_changed)
	EventBus.boss_get_max_health.connect(_set_max_health)

func _set_max_health(boss_max_health) -> void:
	max_value = boss_max_health

func _on_boss_health_changed(current_health) -> void:
	value = current_health
