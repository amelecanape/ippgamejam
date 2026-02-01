class_name TaskManager extends Node

signal all_tasks_finished()
signal task_finished()

@export var amount_of_tasks : int = 5

### Bugging NPC task
@export var important_npc : Array[NPCControl]
@export var npc_bugging_task_scene: PackedScene

func add_important_npc(npc: NPCControl) -> void:
	important_npc.append(npc)
	
