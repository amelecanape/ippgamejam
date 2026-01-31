@abstract
class_name MaskPower extends Node

var mask : Mask

func _ready() -> void:
	mask = get_parent() as Mask
	assert(mask, "MaskPower without Mask!")

@abstract
func execute_ability() -> void
