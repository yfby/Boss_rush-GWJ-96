extends State
class_name BossAttack


@export var player: Player
@export var max_state_time: float = 1
@export var timer: Timer

## when it enters it picks a random attack based on the range
@export var attacks: Array[Attack]

@export_group("Visuals")
@export var boss: Boss
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D




func Enter() -> void:
	#print("entered attack")
	player = get_tree().get_first_node_in_group("Player") as Player
	
	## spawn attack
	var rand_attack = attacks.pick_random()
	var attack_scene = rand_attack.shot_data.instantiate() as ShotBase
	attack_scene.shooter = boss.shoot_point
	attack_scene.target_type = Type.target.PLAYER
	await get_tree().create_timer(rand_attack.charge_time).timeout
	boss.add_child(attack_scene)
	
	## play attack animation
	if animation_player.has_animation(rand_attack.anim_name):
		animation_player.play(rand_attack.anim_name)
	
	if not timer.timeout.is_connected(transition_to_random):
		timer.timeout.connect(transition_to_random)
	timer.wait_time = max_state_time
	timer.start()
	
func transition_to_random() -> void:
	var rand_state: State = transition_States.pick_random()
	#print("should transition to: " + rand_state.name.to_lower())
	Transitioned.emit(self, rand_state.name.to_lower())
	timer.timeout.disconnect(transition_to_random)
