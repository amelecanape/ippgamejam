class_name PlayerControl extends MaskedCharacter

@export var lock_movement : bool = false

@export var player : int

enum PLAYER_ROLE {SPY, DETECTIVE}
@export var role : PLAYER_ROLE = PLAYER_ROLE.SPY

@export var shootable_mask : int

func _ready() -> void:
	super._ready()
	$Camera2D.enabled = player == multiplayer.get_unique_id()
	
func _enter_tree() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(player)
	
func _on_round_start() -> void:
	lock_movement = false

func _process(_delta: float) -> void:
	super._process(_delta)
	if lock_movement or player != multiplayer.get_unique_id():
		return
	if Input.is_action_just_pressed("use_mask_ability") and mask:
		_use_mask_ability.rpc()
	if Input.is_action_just_pressed("use_gun") and role == PLAYER_ROLE.DETECTIVE:
		print("shoot!")
		_shoot.rpc(get_global_mouse_position())
		
@rpc("any_peer", "call_local")
func _use_mask_ability() -> void:
		mask.use_ability()
		
@rpc("any_peer", "call_local")
func _shoot(pos: Vector2) -> void:
	if not multiplayer.is_server():
		return
	var query : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collision_mask = shootable_mask
	var result : Array[Dictionary] = get_world_2d().direct_space_state.intersect_point(query)
	for r in result:
		var area : Area2D = r["collider"] as Area2D
		var masked : MaskedCharacter = area.get_parent()
		if masked != self:
			masked.die.rpc()

func _physics_process(_delta: float) -> void:
	if not lock_movement and player == multiplayer.get_unique_id():
		mov_input = Input.get_vector("character_move_neg_x","character_move_pos_x",\
											   "character_move_neg_y","character_move_pos_y")
	
	super._physics_process(_delta)


func _on_area_collision_area_entered(area: Area2D) -> void:
	if mask == area.get_parent() or player == multiplayer.get_unique_id():
		return
	print("started being jammed!")


func _on_area_collision_area_exited(area: Area2D) -> void:
	if mask == area.get_parent() or player == multiplayer.get_unique_id():
		return
	print("stopped being jammed!")
