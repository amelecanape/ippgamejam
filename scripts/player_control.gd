class_name PlayerControl extends MaskedCharacter

@export var lock_movement : bool = false

func _process(_delta: float) -> void:
	super._process(_delta)
	if lock_movement:
		return
	if Input.is_action_just_pressed("use_mask_ability") and mask:
		mask.use_ability()

func _physics_process(_delta: float) -> void:
	mov_input = Input.get_vector("character_move_neg_x","character_move_pos_x",\
											   "character_move_neg_y","character_move_pos_y")
	if lock_movement:
		mov_input = Vector2.ZERO
	super._physics_process(_delta)
