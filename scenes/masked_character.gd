class_name MaskedCharacter extends CharacterBody2D

@export var movement_speed: float = 250
var mov_input : Vector2

@export var mask : MaskData
@onready var mask_sprite : Sprite2D = $%MaskSprite
@onready var character_sprite : Sprite2D = $%CharacterSprite

func _ready() -> void:
	mask_sprite.texture = mask.mask_sprite

func _process(_delta: float) -> void:
	if not is_zero_approx(mov_input.x):
		character_sprite.flip_h = mov_input.x < 0

func _physics_process(_delta: float) -> void:
	velocity = movement_speed * mov_input
	move_and_slide()
