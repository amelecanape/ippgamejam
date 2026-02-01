class_name MoveItemsSpawner extends MultiplayerSpawner

@export var task_manager : TaskManager

@export var move_item_scene : PackedScene

func _ready() -> void:
	spawn_function = _spawn_item

func _spawn_item(data : Dictionary) -> MoveItem:
	var round: Round = get_parent() as Round
	var item : MoveItem = move_item_scene.instantiate() as MoveItem
	item.global_position = data["spawn_point"]
	item.item_id = data["item_id"]
	item.round = round
	task_manager.add_move_item(item)
	return item
