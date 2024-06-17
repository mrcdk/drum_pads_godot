extends PanelContainer

const PAD_SCENE = preload('res://pad.tscn')

@onready var cutout_spacer: ColorRect = %CutoutSpacer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var pad_container: GridContainer = %PadContainer
@onready var pitch_control_container: PanelContainer = %PitchControlContainer


var sound_pack:SoundPack = preload('res://assets/lofi/lofi_soundpack.tres')

var pitch_scale:float = 1.0

func _ready() -> void:
	var safe_area = DisplayServer.get_display_safe_area()
	if safe_area.position.y > 0:
		cutout_spacer.custom_minimum_size.y = safe_area.position.y - 20

	pitch_control_container.value_changed.connect(func(new_value:int):
		pitch_scale = remap(new_value, -100, 100, 0.5, 1.5)
		print('value changed %s' % new_value)
	)

	var playback := audio_stream_player.get_stream_playback() as AudioStreamPlaybackPolyphonic

	for entry in sound_pack.sounds:
		var pad = PAD_SCENE.instantiate()
		pad_container.add_child(pad)
		pad.color = entry.color
		pad.pressed.connect(func():
			if pad.stream_idx > -1:
				playback.stop_stream(pad.stream_idx)
			pad.stream_idx = playback.play_stream(entry.sound, 0.0, 0.0, pitch_scale)
		)
		pad.released.connect(func():
			pass
		)
