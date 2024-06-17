extends AspectRatioContainer

signal pressed()
signal released()

@export var color = Color.WHITE:
	set(value):
		color = value
		if not is_node_ready():
			await ready
		touch_screen_button.modulate = color

var stream_idx:int = -1

@onready var sprites: Node2D = %Sprites
@onready var touch_screen_button: TouchScreenButton = %TouchScreenButton
@onready var overlay: Sprite2D = %Overlay

var overlay_tween:Tween

func _ready() -> void:
	overlay.modulate.a = 0.0
	resized.connect(func():
		custom_minimum_size = Vector2(size.x, size.x)
		sprites.scale = custom_minimum_size / overlay.texture.get_size()
	)

	touch_screen_button.pressed.connect(func():
		if is_instance_valid(overlay_tween) and overlay_tween.is_running():
			await overlay_tween.finished

		overlay_tween = create_tween().bind_node(overlay).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		overlay_tween.tween_property(overlay, "modulate:a", 1.0, 0.1)

		pressed.emit()
	)

	touch_screen_button.released.connect(func():
		if is_instance_valid(overlay_tween) and overlay_tween.is_running():
			await overlay_tween.finished

		overlay_tween = create_tween().bind_node(overlay).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		overlay_tween.tween_property(overlay, "modulate:a", 0.0, 0.1)

		released.emit()
	)
