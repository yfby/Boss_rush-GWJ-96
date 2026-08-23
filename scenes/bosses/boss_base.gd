extends CharacterBody2D
class_name Boss

@export var shoot_point: Marker2D
@export var player: Player
@export var push_back_box: Area2D
@export var damage_on_pushback: float = 10

@export var max_health: float = 500
@export var current_health: float = 500:
	set(value):
		current_health = clamp(value, 0, max_health)
		EventBus.boss_health_changed.emit(current_health)
		if current_health == 0:
			EventBus.boss_died.emit()
		

func _ready() -> void:
	if push_back_box:
		push_back_box.body_entered.connect(push_away)



func _physics_process(delta: float) -> void:
	if player:
		shoot_point.look_at(player.global_position)
	
	move_and_slide()


func take_damage(amount: float) -> bool:
	print("Boss took " + str(amount) + " damage")
	current_health -= amount
	# TODO: play sfx
	
	## currently just return true becuse boss has no invincible attacks
	return true

func push_away(body) -> void:
	if body is Player:
		body.external_velocity -= (global_position - body.global_position).normalized() * 500
		body.take_damage(damage_on_pushback)


func _on_push_back_box_body_entered(body: Node2D) -> void:
	push_away(body)
