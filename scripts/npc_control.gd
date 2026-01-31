class_name NPCControl extends MaskedCharacter

@onready var navigation_agent : NavigationAgent2D = $%NavigationAgent

@export var DEBUG : bool = false

func _process(_delta: float) -> void:
	if DEBUG and Input.is_action_just_pressed("debug_mouse_left_click"):
		set_movement_target(get_global_mouse_position())
		mask.use_ability()
	super._process(_delta)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	mov_input = global_position.direction_to(next_pos).normalized()
	super._physics_process(_delta)
