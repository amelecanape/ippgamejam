class_name RabbitMask extends Mask

@export var dash_dist : float = 250

var dash_character_mov_input : Vector2 = Vector2.RIGHT

func _process(_delta: float) -> void:
	super._process(_delta)
	if not masked_character.mov_input.is_zero_approx():
		dash_character_mov_input = masked_character.mov_input

func _execute_ability() -> void:
	print("Dashed!")
	masked_character.position += dash_character_mov_input * dash_dist
