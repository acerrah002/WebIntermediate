extends Node2D

var background_wrapper: Control

func _ready() -> void:
	randomize()

	# =========================
	# BACKGROUND
	# =========================
	background_wrapper = Control.new()
	background_wrapper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background_wrapper)

	create_procedural_background()

	get_tree().root.size_changed.connect(_on_window_resized)

	# =========================
	# UI LAYER
	# =========================
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)

	var ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(ui_root)

	# Dark overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.35)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(overlay)

	# Center container
	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(center)

	# Main panel
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(500, 450)
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

	# Layout
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	margin.add_child(vbox)

	# =========================
	# TITLE
	# =========================
	var title = Label.new()
	title.text = "GODOT CHESS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Classic Chess Experience"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.modulate = Color(0.8, 0.8, 0.8)
	vbox.add_child(subtitle)

	vbox.add_child(HSeparator.new())

	# =========================
	# BUTTON STYLES
	# =========================
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
	# PLAY BUTTON
	# =========================
	var play_button = Button.new()
	play_button.text = "♟  Player vs Friend"
	play_button.custom_minimum_size = Vector2(400, 60)
	apply_custom_styles(
		play_button,
		style_normal,
		style_hover,
		style_pressed
	)
	play_button.pressed.connect(_on_play_pressed)
	vbox.add_child(play_button)

	# =========================
	# CREDITS BUTTON
	# =========================
	var credits_button = Button.new()
	credits_button.text = "ⓘ  Credits"
	credits_button.custom_minimum_size = Vector2(400, 60)
	apply_custom_styles(
		credits_button,
		style_normal,
		style_hover,
		style_pressed
	)
	credits_button.pressed.connect(_on_credits_pressed)
	vbox.add_child(credits_button)

	# =========================
	# EXIT BUTTON
	# =========================
	var exit_button = Button.new()
	exit_button.text = "✕  Exit"
	exit_button.custom_minimum_size = Vector2(400, 60)
	apply_custom_styles(
		exit_button,
		style_normal,
		style_hover,
		style_pressed
	)
	exit_button.pressed.connect(func(): get_tree().quit())
	vbox.add_child(exit_button)

	vbox.add_child(HSeparator.new())

	# =========================
	# VERSION LABEL
	# =========================
	var version = Label.new()
	version.text = "Version 1.0"
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.modulate = Color(0.65, 0.65, 0.65)
	version.add_theme_font_size_override("font_size", 12)
	vbox.add_child(version)

	# Fade-in animation
	ui_root.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(ui_root, "modulate:a", 1.0, 0.4)


func create_procedural_background() -> void:
	for child in background_wrapper.get_children():
		child.queue_free()

	var tile_size := 80.0
	var screen_size = get_viewport().get_visible_rect().size

	var columns := int(ceil(screen_size.x / tile_size))
	var rows := int(ceil(screen_size.y / tile_size))

	var white_pieces = ["♔", "♕", "♖", "♗", "♘", "♙"]
	var black_pieces = ["♚", "♛", "♜", "♝", "♞", "♙"]

	var grid = GridContainer.new()
	grid.columns = columns
	grid.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)

	background_wrapper.add_child(grid)

	for i in range(columns * rows):
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(tile_size, tile_size)

		var row = i / columns
		var col = i % columns

		var style = StyleBoxFlat.new()

		if (row + col) % 2 == 0:
			style.bg_color = Color(0.864, 0.692, 0.371)
		else:
			style.bg_color = Color.WHITE

		panel.add_theme_stylebox_override("panel", style)

		if randf() < 0.30:
			var piece = Label.new()

			if randf() < 0.5:
				piece.text = white_pieces[randi() % white_pieces.size()]
				piece.add_theme_color_override(
					"font_color",
					Color(1, 1, 1, 0.35)
				)
			else:
				piece.text = black_pieces[randi() % black_pieces.size()]
				piece.add_theme_color_override(
					"font_color",
					Color(0, 0, 0, 0.35)
				)

			piece.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			piece.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			piece.add_theme_font_size_override(
				"font_size",
				int(tile_size * 0.55)
			)

			panel.add_child(piece)

		grid.add_child(panel)


func _on_window_resized() -> void:
	create_procedural_background()


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


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
