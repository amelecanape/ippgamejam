class_name RabbitMaskPower extends MaskPower

@export var dash_dist : float = 250

var dash_character_mov_input : Vector2 = Vector2.RIGHT
var dash_impulse : Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if not mask.masked_character.mov_input.is_zero_approx():
		dash_character_mov_input = mask.masked_character.mov_input

func _physics_process(delta: float) -> void:
	dash_impulse = dash_character_mov_input * dash_dist / delta

func execute_ability() -> void:
	mask.masked_character.impulse += dash_impulse
