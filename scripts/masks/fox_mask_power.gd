class_name FoxMaskPower extends MaskPower

@export var invisibility_duration : float = 10
@export var invisible_counter : float = 0

func _process(delta: float) -> void:
	mask.masked_character.character_sprite.visible = true
	if invisible_counter > 0:
		mask.masked_character.character_sprite.visible = false
		
	invisible_counter = invisible_counter - delta if invisible_counter > 0 else  0

func execute_ability() -> void:
	invisible_counter = invisibility_duration
