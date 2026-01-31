class_name FoxMaskPower extends MaskPower

@export var invisibility_duration : float = 10
@export var invisible_counter : float = 0

func _process(delta: float) -> void:
	_become_visible()
	if invisible_counter > 0:
		_become_visible(false)
		
	invisible_counter = invisible_counter - delta \
					 if invisible_counter > 0 else  0.0

func _become_visible(visible : bool = true) -> void:
	mask.masked_character.character_sprite.visible = visible
	mask.sprite.visible = visible

func execute_ability() -> void:
	invisible_counter = invisibility_duration
