class_name PlayerControl extends MaskedCharacter

func _process(_delta: float) -> void:
	super._process(_delta)
	if Input.is_action_just_pressed("use_mask_ability") and mask:
		mask.use_ability()

func _physics_process(_delta: float) -> void:
	mov_input = Input.get_vector("character_move_neg_x","character_move_pos_x",\
											   "character_move_neg_y","character_move_pos_y")
	super._physics_process(_delta)
