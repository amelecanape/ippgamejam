class_name RabbitMaskPower extends MaskPower

@export var dash_duration : float = 0.25
var dash_duration_cnt : float = 0
@export var dash_speed : float = 500

var dash_character_mov_input : Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:		
	dash_duration_cnt = dash_duration_cnt - delta \
					 if dash_duration_cnt > 0 else  0.0
	if not mask.masked_character.mov_input.is_zero_approx():
		dash_character_mov_input = mask.masked_character.mov_input

func _physics_process(_delta: float) -> void:
	if dash_duration_cnt > 0:
		mask.masked_character.impulse += dash_character_mov_input * dash_speed

func execute_ability() -> void:
	dash_duration_cnt = dash_duration
	mask.masked_character.play_dash_fx()
