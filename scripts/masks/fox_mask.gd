class_name FoxMask extends Mask

@export var invisibility_duration : float = 10
@export var invisible_counter : float = 0

func _process(delta: float) -> void:
	super._process(delta)
	masked_character.character_sprite.visible = true
	if invisible_counter > 0:
		masked_character.character_sprite.visible = false
		
	invisible_counter = invisible_counter - delta if invisible_counter > 0 else  0

func _execute_ability() -> void:
	invisible_counter = invisibility_duration
