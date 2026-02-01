class_name TaskManager extends Node

signal all_tasks_finished()
signal task_finished(amount: int)

@export var amount_of_tasks : int = 0

### Bugging NPC task
@export var bugging_npc_tasks : Dictionary[int, NPCBuggingTask] = {}
@export var npc_bugging_task_scene: PackedScene

func _on_task_finished() -> void:
	amount_of_tasks -= 1
	task_finished.emit(amount_of_tasks)
	if amount_of_tasks <= 0:
		all_tasks_finished.emit()

func add_important_npc(npc: NPCControl) -> void:
	amount_of_tasks += 1
	var bugging_task : NPCBuggingTask = npc_bugging_task_scene.instantiate()
	npc.add_child(bugging_task, true)
	bugging_task.finished_bugging.connect(_on_finished_bugging_task)
	bugging_npc_tasks[npc.npc_id] = bugging_task

func _on_finished_bugging_task(bugging_task: NPCBuggingTask):
	var npc : NPCControl = bugging_task.get_parent() as NPCControl
	_finished_bugging_npc.rpc(npc.npc_id)

@rpc("call_local", "any_peer")
func _finished_bugging_npc(npc_id: int) -> void:
	bugging_npc_tasks[npc_id].queue_free()
	bugging_npc_tasks.erase(npc_id)
	_on_task_finished()
	
