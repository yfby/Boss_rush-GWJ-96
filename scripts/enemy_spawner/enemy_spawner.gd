extends Node2D

@export var elemental_spawn: Array[PackedScene] = []
@export var spawn_limit = 30

var spawn_points = []

# This is iterating (looking through) the children of the enemy_spawner 
# and is specifically looking for the marker 2D which I have 4 of
# there are 4 so I append them into the spawn_points list variable
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

# The 
func spawn_elements():
	if get_tree().get_nodes_in_group("minions").size() < spawn_limit:
		var minion = elemental_spawn.pick_random().instantiate()
		minion.position = spawn_points.pick_random().position
		
		add_child(minion)

func _on_timer_timeout() -> void:
	spawn_elements()
	


# This is making the spawn positions randomly spawn mobs at different points.
#  I instantiate the mob scene MinionBase to spawn
# at the spawn positions.
# The minions.add_child(minions_spawn) works with the @onready var minions getting the root "enemy_spawner"
# To add a child the elemental sprites to the World scene. 
