@abstract
class_name Mask extends Node
var masked_character : MaskedCharacter
@export var mask_sprite : Texture2D

@export var cool_down_amount: float = 10
var cool_down : float = 0

func is_ability_ready() -> bool:
	return cool_down <= 0

func _ready() -> void:
	masked_character = get_parent() as MaskedCharacter
	assert(masked_character, "Mask without MaskedCharacter!")

func _process(delta: float) -> void:
	cool_down = cool_down - delta if cool_down > 0 else  0.0

func use_ability() -> bool:
	if cool_down > 0:
		return false
	_execute_ability()
	cool_down = cool_down_amount
	return true

@abstract
func _execute_ability() -> void
