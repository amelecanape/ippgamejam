class_name PlayerControl extends MaskedCharacter

@export var lock_movement : bool = false

@export var player : int

enum PLAYER_ROLE {SPY, DETECTIVE}
@export var role : PLAYER_ROLE = PLAYER_ROLE.SPY

func _ready() -> void:
	super._ready()
	$Camera2D.enabled = player == multiplayer.get_unique_id()
	
func _enter_tree() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(player)
	
func _process(_delta: float) -> void:
	super._process(_delta)
	if lock_movement or player != multiplayer.get_unique_id():
		return
	if Input.is_action_just_pressed("use_mask_ability") and mask:
		_use_mask_ability.rpc()
		
@rpc("any_peer", "call_local")
func _use_mask_ability() -> void:
		mask.use_ability()
	

func _physics_process(_delta: float) -> void:
	mov_input = Input.get_vector("character_move_neg_x","character_move_pos_x",\
											   "character_move_neg_y","character_move_pos_y")
	if lock_movement or player != multiplayer.get_unique_id():
		mov_input = Vector2.ZERO
	super._physics_process(_delta)
