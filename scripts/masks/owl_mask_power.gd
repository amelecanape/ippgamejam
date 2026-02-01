class_name OwlMaskPower extends MaskPower

@export var increased_view : float = 2
@export var regular_view : float = 4

@export var view_increase_duration : float = 10
@export var view_increase_counter : float = 0

func _process(delta: float) -> void:
	var player: PlayerControl = mask.masked_character as PlayerControl
	if player:
		player.camera.zoom = Vector2.ONE * regular_view 
	if view_increase_counter > 0:
		if player:
			player.camera.zoom = Vector2.ONE * increased_view
	
	view_increase_counter = view_increase_counter - delta \
					 if view_increase_counter > 0 else  0.0



func execute_ability() -> void:
	view_increase_counter = view_increase_duration
