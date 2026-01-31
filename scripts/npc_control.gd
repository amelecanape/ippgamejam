class_name NPCControl extends MaskedCharacter

@onready var navigation_agent : NavigationAgent2D = $%NavigationAgent
@export var navigation_region : NavigationRegion2D
@export var DEBUG : bool = false

@export var find_new_target_max_delay : float = 10
@export var find_new_target_min_delay : float = 1
var find_new_target_delay_cnt : float = 0
var waiting_for_next_target : bool = true

func _ready() -> void:
	super._ready()
	navigation_agent.target_reached.connect(_on_target_reached)

func _process(delta: float) -> void:
	super._process(delta)
	if not multiplayer.is_server():
		return
	if waiting_for_next_target and navigation_region:
		if find_new_target_delay_cnt <= 0:
			set_movement_target(NavigationServer2D.region_get_random_point(navigation_region.get_rid(), 1, false))
			waiting_for_next_target = false
		else:
			find_new_target_delay_cnt = find_new_target_delay_cnt - delta\
										 if find_new_target_delay_cnt > 0 else 0.0
	

func _on_target_reached() -> void:
	waiting_for_next_target = true
	find_new_target_delay_cnt = randf_range(find_new_target_min_delay, find_new_target_max_delay)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	if not multiplayer.is_server():
		return
	mov_input = Vector2.ZERO
	if navigation_agent.is_navigation_finished():
		return
	var next_pos : Vector2 = navigation_agent.get_next_path_position()
	mov_input = global_position.direction_to(next_pos).normalized()
