class_name Round extends Node2D

signal player_role(role: PlayerControl.PLAYER_ROLE)
signal round_start()
signal round_end(detective_won: bool)

@onready var y_sorted : Node2D = $%ySorted
@onready var nav_region : NavigationRegion2D = $%NavigationRegion2D

@export var player_scene : PackedScene
@export var player_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

@onready var spotlight : PanelContainer = $%SpotlightPanel
const INITIAL_SPOTLIGHT_RADIUS : float = 0.15

@export var amount_of_npcs : int = 10
@onready var masked_spawner : MaskedCharacterSpawner = $%MaskedCharacterSpawner

@export var detective_amount_of_bullets : int = 4
@export var killed_spies : int = 0

const  ROLE_DETECTIVE : String = "You are a DETECTIVE"
const  ROLE_SPY : String = "You are a SPY"
const  REMAINING_SPIES : String = "%d remaining spies"

@onready var role_label : Label = $%RoleLabel
@onready var ability_cooldown : Label = $%AbilityCooldown
@onready var remaining_spies : Label = $%RemainingSpies

var players_that_loaded_scene: int = 0

func _ready():
	assert(nav_region, "Node needs to have a NavigationRegion2D!")
	NavigationServer2D.map_changed.connect(func(_map: RID): spawn_characters())
	spotlight.visible = true
	spotlight.material.set_shader_parameter("radius", INITIAL_SPOTLIGHT_RADIUS)
	_loaded_scene.rpc_id(1) # Tell server (and ourselfs) that we loaded the scene

@rpc("call_local", "any_peer")
func _loaded_scene():
	players_that_loaded_scene += 1
	if players_that_loaded_scene < Lobby.connected_players.size():
		return
	print("all players loaded")
	$RoundStartDelay.start()
	print("delay to start round")

func _on_round_start_delay_timeout() -> void:
	start_game.rpc()

func _on_npc_died() -> void:
	detective_amount_of_bullets -= 1
	if not multiplayer.is_server():
		return
	if detective_amount_of_bullets < Lobby.connected_players.size() - 1:
		print("Detective lost!")
		round_end.emit(false)
func _on_player_died() -> void:
	detective_amount_of_bullets -= 1
	killed_spies += 1
	remaining_spies.text = REMAINING_SPIES % [Lobby.connected_players.size() - 1 - killed_spies]
	if not multiplayer.is_server():
		return
	if killed_spies == Lobby.connected_players.size() - 1:
		print("Detective won!")
		round_end.emit(true)
	
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
	return randi_range(0, masked_spawner.masks_scenes.size() - 1)

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
		set_player_role.rpc_id(id, role)
	
@rpc("call_local")
func set_player_role(role: PlayerControl.PLAYER_ROLE) -> void:
	player_role.emit(role)
	role_label.text = ROLE_DETECTIVE if role == PlayerControl.PLAYER_ROLE.DETECTIVE\
							else ROLE_SPY
