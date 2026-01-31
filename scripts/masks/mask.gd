class_name Mask extends Node2D
var masked_character : MaskedCharacter
var mask_power : MaskPower
@onready var sprite : Sprite2D = $%Sprite

@export var cool_down_amount: float = 10
var cool_down : float = 0

func is_ability_ready() -> bool:
	return cool_down <= 0

func _ready() -> void:
	for c in get_children():
		if c is MaskPower:
			mask_power = c as MaskPower
			break
	assert(mask_power, "No MaskPower child node in Mask!")

func _process(delta: float) -> void:
	cool_down = cool_down - delta if cool_down > 0 else  0.0

func use_ability() -> bool:
	if cool_down > 0:
		return false
	mask_power.execute_ability()
	cool_down = cool_down_amount
	return true
