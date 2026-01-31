class_name DeerMaskPower extends MaskPower

@export var jam_duration : float = 10
@export var jam_counter : float = 0

@export var waves_fx : AnimatedSprite2D
@export var jammed_area_collider : CollisionShape2D

func _process(delta: float) -> void:
	if jam_counter <= 0:
		waves_fx.stop()
		waves_fx.visible = false
		jammed_area_collider.set_deferred("disabled", true)
		
	jam_counter = jam_counter - delta \
				if jam_counter > 0 else  0.0

func execute_ability() -> void:
	jam_counter = jam_duration
	waves_fx.play("waves")
	waves_fx.visible = true
	jammed_area_collider.set_deferred("disabled", false)
