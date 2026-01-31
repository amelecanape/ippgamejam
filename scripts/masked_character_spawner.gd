class_name MaskedCharacterSpawner extends MultiplayerSpawner

@export var nav_region : NavigationRegion2D

@export var npc_scene : PackedScene
@export var player_scene : PackedScene

@export var skins_sprite_frames : Array[SpriteFrames]
@export var masks_scenes : Array[PackedScene]

func _ready() -> void:
	spawn_function = _spawn_masked

func _spawn_masked(data : Dictionary) -> MaskedCharacter:
	var masked : MaskedCharacter
	if data.has("player"):
		var player : PlayerControl = player_scene.instantiate() as PlayerControl
		player.player = data["player"]
		masked = player
	else:
		var npc : NPCControl = npc_scene.instantiate() as NPCControl
		npc.navigation_region = nav_region
		masked = npc
	return _configure_masked(data, masked)
	
func _configure_masked(data, masked : MaskedCharacter) -> MaskedCharacter:
	var spawn_point : Vector2 = data["spawn_point"]
	var skin_index : int = data["skin_index"]
	var mask_index : int = data["mask_index"]
	masked.character_frames = skins_sprite_frames[skin_index]
	masked.global_position = spawn_point
	masked.set_mask(masks_scenes[mask_index].instantiate() as Mask)
	return masked
	
