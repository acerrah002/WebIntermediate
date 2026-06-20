extends Control

# --- CUSTOMIZE THIS FOR EACH SCENE ---
var target_username: String = ""
var hobbies_text: String = "• Coding\n• Math\n• Video Games"

# NOTE: Make sure you drag your images into your Godot project's FileSystem!
# Change these paths to where your images are saved in Godot (e.g., "res://images/Roblox.png")
var slideshow_data: Array = [
	{
		"image_path": "res://icon.svg", # Replace with your actual image path
		"description": "Immersive 3D world building, Luau scripting, and UX design in Roblox."
	},
	{
		"image_path": "res://icon.svg", # Replace with your actual image path
		"description": "Python development focused on computer vision, automation, and Pygame."
	}
]
# -------------------------------------

var current_slide: int = 0
var avatar_rect: TextureRect
var bio_label: Label
var repo_label: RichTextLabel
var slide_image: TextureRect
var slide_desc: Label

func _ready() -> void:
	# Automatically grab the scene's filename and strip out the path and ".tscn"
	target_username = scene_file_path.get_file().get_basename()
	# Set background color (matching your CSS: rgb(226, 248, 248))
	var bg = ColorRect.new()
	bg.color = Color(0.886, 0.972, 0.972)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	_build_ui_layout()
	_update_slideshow()
	_fetch_github_profile()

# ==========================================
# UI GENERATION (Replacing HTML/CSS)
# ==========================================
func _build_ui_layout() -> void:
	var main_hbox = HBoxContainer.new()
	main_hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_hbox.add_theme_constant_override("separation", 20)
	#main_hbox.set_offset(MARGIN_LEFT, 15)
	#main_hbox.set_offset(MARGIN_TOP, 15)
	#main_hbox.set_offset(MARGIN_RIGHT, -15)
	#main_hbox.set_offset(MARGIN_BOTTOM, -15)
	add_child(main_hbox)
	
	# --- LEFT SIDEBAR ---
	var sidebar = PanelContainer.new()
	sidebar.custom_minimum_size = Vector2(300, 0)
	var sb_style = StyleBoxFlat.new()
	sb_style.bg_color = Color(0.82, 0.933, 0.933) # rgb(209, 238, 238)
	sb_style.set_corner_radius_all(20)
	sidebar.add_theme_stylebox_override("panel", sb_style)
	main_hbox.add_child(sidebar)
	
	var sb_vbox = VBoxContainer.new()
	sb_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	sb_vbox.add_theme_constant_override("separation", 15)
	sidebar.add_child(sb_vbox)
	
	var name_lbl = Label.new()
	name_lbl.text = target_username
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 28)
	name_lbl.add_theme_color_override("font_color", Color.BLACK)
	sb_vbox.add_child(name_lbl)
	
	avatar_rect = TextureRect.new()
	avatar_rect.custom_minimum_size = Vector2(200, 200)
	avatar_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	avatar_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	sb_vbox.add_child(avatar_rect)
	
	bio_label = Label.new()
	bio_label.text = "Loading Bio..."
	bio_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	bio_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bio_label.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	sb_vbox.add_child(bio_label)
	
	var hobbies_lbl = Label.new()
	hobbies_lbl.text = "Interests:\n" + hobbies_text
	hobbies_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hobbies_lbl.add_theme_color_override("font_color", Color.BLACK)
	sb_vbox.add_child(hobbies_lbl)

	# --- RIGHT PAGE (Slideshow & Repos) ---
	var page_vbox = VBoxContainer.new()
	page_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page_vbox.add_theme_constant_override("separation", 30)
	page_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_hbox.add_child(page_vbox)
	
	var exp_title = Label.new()
	exp_title.text = "Coding Experience"
	exp_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	exp_title.add_theme_font_size_override("font_size", 32)
	exp_title.add_theme_color_override("font_color", Color.BLACK)
	page_vbox.add_child(exp_title)
	
	# Slideshow Controls
	var slide_controls = HBoxContainer.new()
	slide_controls.alignment = BoxContainer.ALIGNMENT_CENTER
	slide_controls.add_theme_constant_override("separation", 20)
	page_vbox.add_child(slide_controls)
	
	var btn_prev = Button.new()
	btn_prev.text = "  <  "
	btn_prev.pressed.connect(func(): current_slide -= 1; _update_slideshow())
	slide_controls.add_child(btn_prev)
	
	var slide_container = VBoxContainer.new()
	slide_controls.add_child(slide_container)
	
	slide_image = TextureRect.new()
	slide_image.custom_minimum_size = Vector2(400, 250)
	slide_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	slide_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	slide_container.add_child(slide_image)
	
	slide_desc = Label.new()
	slide_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	slide_desc.custom_minimum_size = Vector2(400, 0)
	slide_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	slide_desc.add_theme_color_override("font_color", Color.BLACK)
	slide_container.add_child(slide_desc)
	
	var btn_next = Button.new()
	btn_next.text = "  >  "
	btn_next.pressed.connect(func(): current_slide += 1; _update_slideshow())
	slide_controls.add_child(btn_next)
	
	# Repositories Section
	var repo_title = Label.new()
	repo_title.text = "Recent GitHub Repositories"
	repo_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	repo_title.add_theme_font_size_override("font_size", 24)
	repo_title.add_theme_color_override("font_color", Color.BLACK)
	page_vbox.add_child(repo_title)
	
	repo_label = RichTextLabel.new()
	repo_label.bbcode_enabled = true
	repo_label.fit_content = true
	repo_label.text = "[center][color=black]Fetching repos...[/color][/center]"
	page_vbox.add_child(repo_label)

	# Back Button
	var back_btn = Button.new()
	back_btn.text = "Return to Credits Menu"
	back_btn.custom_minimum_size = Vector2(200, 50)
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://credits.tscn"))
	page_vbox.add_child(back_btn)

# ==========================================
# SLIDESHOW LOGIC (Replacing your JS array)
# ==========================================
func _update_slideshow() -> void:
	if slideshow_data.size() == 0: return
	
	# Keep index in bounds (looping)
	if current_slide < 0: current_slide = slideshow_data.size() - 1
	if current_slide >= slideshow_data.size(): current_slide = 0
	
	var data = slideshow_data[current_slide]
	slide_desc.text = data["description"]
	
	# Load the image from Godot's resource system
	if ResourceLoader.exists(data["image_path"]):
		slide_image.texture = load(data["image_path"])
	else:
		slide_desc.text += "\n[Image not found at path!]"

# ==========================================
# GITHUB API LOGIC (Replacing JS Fetch)
# ==========================================
func _fetch_github_profile() -> void:
	# 1. Fetch Profile Info
	var profile_req = HTTPRequest.new()
	add_child(profile_req)
	profile_req.request_completed.connect(func(_res, code, _hdrs, body):
		if code == 200:
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data:
			# 1. Update the Bio, but only if the label exists
				if is_instance_valid(bio_label):
					bio_label.text = data.get("bio") if data.get("bio") != null else "No bio available."
			
			# 2. Update the Avatar
				_fetch_avatar(data.get("avatar_url", ""))
			
		profile_req.queue_free()
	)
	profile_req.request("https://api.github.com/users/" + target_username, ["User-Agent: GodotEngine"])
	
	# 2. Fetch Repos
	var repo_req = HTTPRequest.new()
	add_child(repo_req)
	repo_req.request_completed.connect(func(res, code, hdrs, body):
		if code == 200:
			var data = JSON.parse_string(body.get_string_from_utf8())
			if typeof(data) == TYPE_ARRAY:
				var txt = "[center][color=black]"
				for repo in data:
					if typeof(repo) == TYPE_DICTIONARY and repo.has("name"):
						txt += "• " + repo["name"] + "\n"
				txt += "[/color][/center]"
				repo_label.text = txt
		repo_req.queue_free()
	)
	repo_req.request("https://api.github.com/users/" + target_username + "/repos?sort=updated&per_page=3", ["User-Agent: GodotEngine"])

func _fetch_avatar(url: String) -> void:
	if url == "": return
	var img_req = HTTPRequest.new()
	add_child(img_req)
	img_req.request_completed.connect(func(res, code, hdrs, body):
		if code == 200:
			var img = Image.new()
			if img.load_png_from_buffer(body) != OK: img.load_jpg_from_buffer(body)
			avatar_rect.texture = ImageTexture.create_from_image(img)
		img_req.queue_free()
	)
	img_req.request(url, ["User-Agent: GodotEngine"])
