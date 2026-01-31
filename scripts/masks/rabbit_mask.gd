class_name RabbitMask extends Mask

@export var dash_dist : float = 250

var dash_character_mov_input : Vector2 = Vector2.RIGHT
var dash_impulse : Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	super._process(_delta)
	if not masked_character.mov_input.is_zero_approx():
		dash_character_mov_input = masked_character.mov_input

func _physics_process(delta: float) -> void:
	dash_impulse = dash_character_mov_input * dash_dist / delta

func _execute_ability() -> void:
	masked_character.impulse += dash_impulse
