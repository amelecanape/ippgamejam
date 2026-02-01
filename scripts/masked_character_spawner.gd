class_name MaskedCharacterSpawner extends MultiplayerSpawner

@export var map : Map
@export var task_manager : TaskManager

@export var npc_scene : PackedScene
@export var player_scene : PackedScene

@export var skins_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

func _ready() -> void:
	spawn_function = _spawn_masked

func _spawn_masked(data : Dictionary) -> MaskedCharacter:
	var masked : MaskedCharacter
	var round: Round = get_parent() as Round
	if data.has("player"):
		var player : PlayerControl = player_scene.instantiate() as PlayerControl
		player.player = data["player"]
		player.role = data["role"]
		player.lock_movement = true
		round.round_start.connect(player._on_round_start)
		masked = player
		masked.died.connect(round._on_player_died)
	else:
		var npc : NPCControl = npc_scene.instantiate() as NPCControl
		npc.navigation_region = map.nav_region
		npc.npc_id = data["npc_id"]
		masked = npc
		masked.died.connect((get_parent() as Round)._on_npc_died)
		if data["important"]:
			task_manager.add_important_npc(npc)
	masked.round = round
	return _configure_masked(data, masked)
	
func _configure_masked(data, masked : MaskedCharacter) -> MaskedCharacter:
	var spawn_point : Vector2 = data["spawn_point"]
	var skin_index : int = data["skin_index"]
	var mask_index : int = data["mask_index"]
	masked.character_frames = skins_sprite_frames[skin_index]
	masked.global_position = spawn_point
	masked.set_mask(masks_scenes[mask_index].instantiate() as Mask)
	return masked
	
