class_name MaskedCharacter extends CharacterBody2D

signal died()

@export var movement_speed: float = 250
@export var mov_input : Vector2 = Vector2.ZERO
var impulse : Vector2 = Vector2.ZERO

@export var character_frames : SpriteFrames

var mask : Mask
@onready var mask_slot : Node2D = $%MaskSlot
var mask_base_position : Vector2
@onready var character_sprite : AnimatedSprite2D = $%CharacterSprite

@onready var graphics : Node2D = $%Graphics

var is_dead : bool

func _ready() -> void:
	if character_frames:
		character_sprite.sprite_frames = character_frames
	character_sprite.play("idle")
	character_sprite.frame_changed.connect(_on_character_frame_changed)
	is_dead = false
	#assert(mask, "No mask child node in MaskedCharacter!")
	#mask_sprite.texture = mask.mask_sprite
	mask_base_position = mask_slot.position

@rpc("call_local")
func die() -> void:
	character_sprite.rotation_degrees = 90
	is_dead = true
	process_mode = Node.PROCESS_MODE_DISABLED
	died.emit()

func set_mask(new_mask: Mask) -> void:
	if mask:
		mask.queue_free()
	mask = new_mask
	mask.masked_character = self
	$%MaskSlot.add_child(mask)
	mask.position = Vector2.ZERO
	
@rpc("any_peer", "call_local")
func play_dash_fx() -> void:
	$%DashFx.play("dash")

func _process(_delta: float) -> void:
	if not is_zero_approx(mov_input.x):
		graphics.scale.x = -1 if mov_input.x < 0 else 1
		
	if not mov_input.is_zero_approx():
		character_sprite.play("walk")
	else:
		character_sprite.play("idle")
		
func _on_character_frame_changed() -> void:
	mask_slot.position.y = mask_base_position.y - character_sprite.frame % 2

func _physics_process(_delta: float) -> void:
	velocity = movement_speed * mov_input + impulse
	impulse = Vector2.ZERO
	move_and_slide()
