extends Node2D

const DEVELOPERS: Array = [
	"plasmaHD2",
	"jyzm1215",
	"acerrah002"
]

func _ready() -> void:
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)

	var ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(ui_root)

	# Same dark overlay as main menu
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.35)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(overlay)

	# Center everything
	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(center)

	# Main panel
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(500, 500)
	center.add_child(panel)

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.08, 0.08, 0.08, 0.92)
	panel_style.border_color = Color(0.8, 0.8, 0.8)
	panel_style.border_width_left = 2
	panel_style.border_width_right = 2
	panel_style.border_width_top = 2
	panel_style.border_width_bottom = 2
	panel_style.set_corner_radius_all(18)

	panel.add_theme_stylebox_override("panel", panel_style)

	# Margins
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 30)
	margin.add_theme_constant_override("margin_right", 30)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	margin.add_child(vbox)

	# =========================
	# TITLE
	# =========================
	var title = Label.new()
	title.text = "CREDITS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Development Team"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.modulate = Color(0.8, 0.8, 0.8)
	vbox.add_child(subtitle)

	vbox.add_child(HSeparator.new())

	# Button styles (same as main menu)
	var style_normal = create_button_style(
		Color(0.18, 0.18, 0.18), 12
	)

	var style_hover = create_button_style(
		Color(0.28, 0.28, 0.28), 12
	)

	var style_pressed = create_button_style(
		Color(0.10, 0.10, 0.10), 12
	)

	# =========================
	# DEVELOPER BUTTONS
	# =========================
	for dev in DEVELOPERS:
		var btn = Button.new()
		btn.text = "👤  " + dev
		btn.custom_minimum_size = Vector2(400, 60)

		apply_custom_styles(
			btn,
			style_normal,
			style_hover,
			style_pressed
		)

		btn.pressed.connect(_on_dev_button_pressed.bind(dev))
		vbox.add_child(btn)

	vbox.add_child(HSeparator.new())

	# Back Button
	var back_btn = Button.new()
	back_btn.text = "← Return to Menu"
	back_btn.custom_minimum_size = Vector2(400, 60)

	apply_custom_styles(
		back_btn,
		style_normal,
		style_hover,
		style_pressed
	)

	back_btn.pressed.connect(_on_back_button_pressed)
	vbox.add_child(back_btn)

	# Footer
	var footer = Label.new()
	footer.text = "Godot Chess Credits"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.modulate = Color(0.65, 0.65, 0.65)
	footer.add_theme_font_size_override("font_size", 12)
	vbox.add_child(footer)

	# Fade-in animation
	ui_root.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(ui_root, "modulate:a", 1.0, 0.4)

func create_button_style(bg_color: Color, radius: int) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()

	style.bg_color = bg_color
	style.border_color = Color(0.45, 0.45, 0.45)

	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1

	style.set_corner_radius_all(radius)
	style.set_content_margin_all(12)

	return style

func apply_custom_styles(
	button: Button,
	normal: StyleBoxFlat,
	hover: StyleBoxFlat,
	pressed: StyleBoxFlat
) -> void:
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_font_size_override("font_size", 20)

func _on_dev_button_pressed(dev_name: String) -> void:
	get_tree().change_scene_to_file("res://" + dev_name + ".tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
