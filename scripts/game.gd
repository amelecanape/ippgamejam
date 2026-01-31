class_name Round extends Node2D

signal round_start()

@onready var y_sorted : Node2D = $%ySorted
@onready var nav_region : NavigationRegion2D = $%NavigationRegion2D

@export var player_scene : PackedScene
@export var player_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

@onready var spotlight : PanelContainer = $%SpotlightPanel
const INITIAL_SPOTLIGHT_RADIUS : float = 0.15

@export var amount_of_npcs : int = 10
@onready var masked_spawner : MaskedCharacterSpawner = $%MaskedCharacterSpawner

func _ready():
	assert(nav_region, "Node needs to have a NavigationRegion2D!")
	NavigationServer2D.map_changed.connect(func(_map: RID): spawn_characters())
	spotlight.visible = true
	spotlight.material.set_shader_parameter("radius", INITIAL_SPOTLIGHT_RADIUS)

@rpc("call_local")
func start_game():
	round_start.emit()
	spotlight.visible = false
	
var has_spawned : bool = false

func _get_random_spawn() -> Vector2:
	return NavigationServer2D.region_get_random_point(nav_region.get_rid(), 1, false)

func _get_random_skin_index() -> int:
	return randi_range(0, masked_spawner.skins_sprite_frames.size() - 1)
	
func _get_random_mask_index() -> int:
	return randi_range(0, masked_spawner.skins_sprite_frames.size() - 1)

func spawn_characters() -> void:
	if not multiplayer.is_server():
		return
	if has_spawned:
		return
	has_spawned = true
	for i in range(amount_of_npcs):
		masked_spawner.spawn({"spawn_point": _get_random_spawn(),\
							  "skin_index":  _get_random_skin_index(),\
							  "mask_index":  _get_random_mask_index()})
	var random_detective : int = randi_range(0, Lobby.connected_players.size() - 1)
	var detective_id : int = Lobby.connected_players.keys()[random_detective]
	for id in Lobby.connected_players:
		var role : PlayerControl.PLAYER_ROLE = PlayerControl.PLAYER_ROLE.DETECTIVE\
						  if detective_id == id else PlayerControl.PLAYER_ROLE.SPY
		masked_spawner.spawn({"spawn_point": _get_random_spawn(),\
							  "skin_index":  _get_random_skin_index(),\
							  "mask_index":  _get_random_mask_index(),\
							  "player": id,\
							  "role": role})
	start_game.rpc()
