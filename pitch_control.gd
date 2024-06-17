@tool
extends Control

signal value_changed(new_value)

@export var value:int = 0:
	set(v):
		if not v == value:
			value_changed.emit(v)
		value = v
		queue_redraw()


var hold_enabled = false

var touch_idx = -1

func _draw() -> void:
	var middle = ceil(size.x / 2.0)
	var start_x = middle - 1
	var width = 2
	if value < 0:
		width = clamp(remap(value, -100, 0, middle, 0), 0, middle)
		start_x = middle - width
	elif value > 0:
		width = clamp(remap(value, 0, 100, 0, middle), 0, middle)
	draw_rect(Rect2(start_x, 0, width, size.y), Color.YELLOW)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if touch_idx < 0:
			touch_idx = event.index
		if touch_idx == event.index:
			value = remap(event.position.x, 0, size.x, -100, 100)
			if not event.pressed:
				touch_idx = -1
				if not hold_enabled:
					value = 0

	if event is InputEventScreenDrag:
		if touch_idx == event.index:
			value = remap(event.position.x, 0, size.x, -100, 100)



func _on_pitch_hold_button_toggled(toggled_on: bool) -> void:
	hold_enabled = toggled_on
	if not hold_enabled:
		value = 0
