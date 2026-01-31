class_name ConnectPlayerLabel extends Label

@export var player_id : int
@export var player_name : String

func _ready() -> void:
	text = "%s (%d)" % [player_name, player_id]
