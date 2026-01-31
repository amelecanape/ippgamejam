class_name Round extends Node2D

signal round_start()

@onready var y_sorted : Node2D = $%ySorted
@onready var nav_region : NavigationRegion2D = $%NavigationRegion2D

@export var player_scene : PackedScene
@export var player_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

var player : PlayerControl
@onready var spotlight : PanelContainer = $%SpotlightPanel
const INITIAL_SPOTLIGHT_RADIUS : float = 0.15

func _ready():
	assert(nav_region, "Node needs to have a NavigationRegion2D!")
	NavigationServer2D.map_changed.connect(func(map: RID): spawn_player())
	spotlight.visible = true
	spotlight.material.set_shader_parameter("radius", INITIAL_SPOTLIGHT_RADIUS)

func start_game():
	round_start.emit()
	player.lock_movement = false
	spotlight.visible = false
	
var has_spawned : bool = false

func spawn_player() -> void:
	if has_spawned:
		return
	print("spawning player!")
	has_spawned = true
	var spawn_point : Vector2 = NavigationServer2D.region_get_random_point(nav_region.get_rid(), 1, false)
	var skin_index : int = randi_range(0, player_sprite_frames.size() - 1)
	var mask_index : int = randi_range(0, masks_scenes.size() - 1)
	player = player_scene.instantiate() as PlayerControl
	player.character_frames = player_sprite_frames[skin_index]
	y_sorted.add_child(player)
	player.global_position = spawn_point
	player.set_mask(masks_scenes[mask_index].instantiate() as Mask)
	player.lock_movement = true
	start_game()
	### Telling the player we loaded into the scene
	#Lobby.player_loaded.rpc_id(1)
