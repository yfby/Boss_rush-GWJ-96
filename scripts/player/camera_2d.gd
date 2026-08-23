class_name PlayerCamera
extends Camera2D

@export_group("Follow")
@export var follow_speed = 6.0  # Higher = snappier, lower = more floaty
@export var camera_offset = Vector2(0, 0)
@export var look_ahead_amount = Vector2(10.0, 10.0)  # Separate X/Y strength
@export var look_ahead_speed = 3.0

@export_group("Shake")
@export var shake_decay = 1.5
@export var sustained_decay = 3.0
@export var max_shake_offset = Vector2(30, 30)
@export var max_shake_roll = 0.05
@export var noise_frequency = 0.5
@export var noise_speed = 20.0

var player: CharacterBody2D
var look_ahead_offset = Vector2.ZERO

var trauma = 0.0
var sustained_trauma = 0.0
var trauma_power = 2.0
var _noise := FastNoiseLite.new()
var _noise_t = 0.0

func _ready():
	player = get_parent()
	_noise.seed = randi()
	_noise.frequency = noise_frequency

func _process(delta):
	if not player:
		return

	var target_pos = player.global_position + camera_offset
	global_position = global_position.lerp(target_pos, 1.0 - exp(-follow_speed * delta))

	var target_look_ahead = Vector2.ZERO
	if player.velocity.x != 0:
		target_look_ahead.x = sign(player.velocity.x) * look_ahead_amount.x
	if player.velocity.y != 0:
		target_look_ahead.y = sign(player.velocity.y) * look_ahead_amount.y

	look_ahead_offset = look_ahead_offset.lerp(target_look_ahead, 1.0 - exp(-look_ahead_speed * delta))
	global_position += look_ahead_offset * delta * 10

	_update_shake(delta)


func _update_shake(delta):
	if trauma > 0.0:
		trauma = max(trauma - shake_decay * delta, 0.0)

	if sustained_trauma > 0.0:
		sustained_trauma = max(sustained_trauma - sustained_decay * delta, 0.0)

	var total_trauma = clamp(trauma + sustained_trauma, 0.0, 1.0)
	var shake_amount = pow(total_trauma, trauma_power)

	_noise_t += delta * noise_speed

	var offset_x = max_shake_offset.x * shake_amount * _noise.get_noise_2d(1.0, _noise_t)
	var offset_y = max_shake_offset.y * shake_amount * _noise.get_noise_2d(100.0, _noise_t)
	var roll = max_shake_roll * shake_amount * _noise.get_noise_2d(200.0, _noise_t)

	offset = Vector2(offset_x, offset_y)
	rotation = roll


func add_trauma(strength: float):
	trauma = clamp(trauma + strength, 0.0, 1.0)

func shake(strength: float = 0.5):
	add_trauma(strength)

func shake_continuous(strength: float):
	sustained_trauma = max(sustained_trauma, clamp(strength, 0.0, 1.0))
