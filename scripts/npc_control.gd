class_name NPCControl extends MaskedCharacter

var target : Node2D = null

@onready var navigation_agent : NavigationAgent2D = $%NavigationAgent

@export var DEBUG : bool = false

func _process(_delta: float) -> void:
	if DEBUG and Input.is_action_just_pressed("debug_mouse_left_click"):
		navigation_agent.target_position = get_global_mouse_position()
func _physics_process(_delta: float) -> void:
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	mov_input = (next_pos - global_position).normalized()
	super._physics_process(_delta)
