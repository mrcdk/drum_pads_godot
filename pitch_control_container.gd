extends PanelContainer

signal value_changed(new_value:int)
@onready var pitch_control: Control = %PitchControl


func _ready() -> void:
	pitch_control.value_changed.connect(func(new_value:int):
		value_changed.emit(new_value)
	)
