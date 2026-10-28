extends HSlider
## Desenvolvido por Desenvolvido por: https://godotshaders.com/shader/pill-slider/
## Optional bridge script for pill_slider.gdshader.
## Attach to an HSlider, assign a ShaderMaterial using pill_slider.gdshader
## to `shader_material` in the inspector, and this will keep the shader's
## `fill_ratio` and `slider_aspect` in sync automatically.

@export var shader_material: ShaderMaterial
@export var fill_grow_duration: float = 0.12

var bar: ColorRect
var _tween: Tween


func _ready() -> void:
	if not shader_material:
		push_error("pill_slider_bridge: assign a ShaderMaterial in the inspector.")
		return

	bar = ColorRect.new()
	bar.color = Color.WHITE
	bar.material = shader_material
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.z_index = 1
	add_child(bar)

	value_changed.connect(_on_value_changed)
	resized.connect(_sync_size)

	call_deferred("_sync_size")


func _sync_size() -> void:
	bar.size = size
	if size.y > 0.0:
		shader_material.set_shader_parameter("slider_aspect", size.x / size.y)
	_on_value_changed(value)


func _on_value_changed(_value: float) -> void:
	var val: float = (value - min_value) / max(0.001, max_value - min_value)
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(shader_material, "shader_parameter/fill_ratio", val, fill_grow_duration)
