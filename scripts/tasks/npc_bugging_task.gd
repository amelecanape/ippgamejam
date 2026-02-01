class_name NPCBuggingTask extends Node2D

signal finished_bugging()

@export var bugging_increase_rate: float = 10
@export var bugging_decline_rate: float = 5
var bugged_porcentage: float = 0
