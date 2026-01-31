class_name NPCSpawner extends Node

@export var nav_region : NavigationRegion2D
@export var navigation_layer : int = 0

@export var amount_of_npcs : int = 10
@export var npc_scene : PackedScene
@export var npc_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

func _ready() -> void:
	assert(nav_region, "Node needs to have a NavigationRegion2D!")

var done : bool = false
func _process(delta: float) -> void:
	if not done:
		spawn_npcs()
		done = true

func spawn_npcs() -> void:
	for i in range(amount_of_npcs):
		var spawn_point : Vector2 = NavigationServer2D.region_get_random_point(nav_region.get_rid(), 1, false)
		print("Spawnpoint: ", spawn_point)
		var npc_index = randi_range(0, npc_sprite_frames.size() - 1)
		var mask_index = randi_range(0, masks_scenes.size() - 1)
		var npc : NPCControl = npc_scene.instantiate() as NPCControl
		npc.character_frames = npc_sprite_frames[npc_index]
		npc.navigation_region = nav_region
		add_child(npc)
		npc.global_position = spawn_point
		npc.set_mask(masks_scenes[mask_index].instantiate() as Mask)
