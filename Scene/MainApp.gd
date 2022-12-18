extends Control

onready var dict_content_view = $"MainEditor/Sets_Dict/DictionaryPanel/Dictionary/Panel/Content"
onready var dict_tree = dict_content_view.get_node("Tree")
onready var dict_raw = dict_content_view.get_node("Raw")

onready var log_node = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Editor/LogContainer/Logs"

onready var dict_stat_hint = $"EditorContainer/Main/UpperBar/Stats/GlobalDict"
onready var img_stat_hint = $"EditorContainer/Main/UpperBar/Stats/GlobalPortrait"

onready var config_files	= $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Editor/Inputs/BrowseBtn"
onready var dict_browse_btn	= config_files.get_node("Dict/Button")
onready var img_browse_btn	= config_files.get_node("Portrait/Button")

onready var load_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Editor/Inputs/Templates/Load/Button"

onready var tooltip_label = $"StartScreen/CenterContainer/VBoxContainer/HintTooltip/LabelText"

func _ready():

	glbl.main_app = self
	glbl.current_dict = null

	glbl.set_crawler_popup = $PopUpContainer/CrawlerSetWarning

	dict_stat_hint.text = "No global dictionary selected"
	log_start( "Waiting input..." )

func log_start(message :String):
	log_node.append_bbcode( message )
	log_node.newline()

func _process(_delta):


	$StartScreen.visible = !$MainEditor.visible
	$TextureRect.visible = $StartScreen.visible


	if $StartScreen.visible:

		# Or the "Start" button
		load_btn.disabled = (
			glbl.current_dict == null or
				(
				img_browse_btn.get_parent().get_node("Use").pressed and
				glbl.current_portrait == null
				)
			)


		dict_browse_btn.get_node("../OK").visible = glbl.current_dict != null
		if glbl.current_dict != null:
			dict_browse_btn.text = " Remove dict."
			dict_browse_btn.set_pressed(true)
		else:
			dict_browse_btn.text = " Select dict."
			dict_browse_btn.set_pressed(false)


		for input_chd in config_files.get_children():
			if input_chd.get_name() != "Dict":
				if input_chd.get_children().size() >= 1:
					for input_btn in input_chd.get_children():
						if input_btn is BaseButton:
							input_btn.disabled = glbl.current_dict == null


		img_browse_btn.get_node("../OK").visible = glbl.current_portrait != null
		if glbl.current_portrait != null:
			img_browse_btn.text = " Remove portraits"
			img_browse_btn.set_pressed(true)
		else:
			img_browse_btn.text = " Select portraits"
			img_browse_btn.set_pressed(false)

		glbl.dict_cfg.use_custom_color = config_files.get_node("Color/Use").pressed
		glbl.dict_cfg.use_custom_speed = config_files.get_node("Speed/Use").pressed

	else:
		dict_tree.visible = !dict_raw.visible


func set_tooltiphint( messag = "" ):
	if messag != "":
		tooltip_label.text = messag
	else:
		tooltip_label.text = "nnda.itch.io"


func _build_dict_tree(
	show_config = true,
	show_blank = false
	):

	dict_raw.text = var2str( glbl.current_dict )

	dict_tree.clear()
	dict_tree.set_column_title(0,"Dictionary")
	dict_tree.set_columns(2)

	var root = dict_tree.create_item()

	dict_tree.set_hide_root(true)

	if show_config:

		var config_sub = dict_tree.create_item(root)
		config_sub.set_text(0, "Config")

		for config_itm in glbl.dict_cfg.keys():

			var cfg_name = dict_tree.create_item(config_sub)
			cfg_name.set_text( 0, str(config_itm) )
			cfg_name.set_text( 1, str(glbl.dict_cfg[config_itm]) )


	var actor_sub = dict_tree.create_item(root)
	actor_sub.set_text(0, "Characters")

	for actor in glbl.dict_chr.keys():

		Tree_AddChrs( actor_sub, actor, show_blank )


func Tree_AddChrs( tree_target, actor, show_blank ):
	var icon_size = 16

	var child = dict_tree.create_item(tree_target)
	var actor_color = Color8(
				glbl.dict_chr[actor]["color"][0],
				glbl.dict_chr[actor]["color"][1],
				glbl.dict_chr[actor]["color"][2]
				)
	child.set_text( 0, actor)
	child.set_icon( 0, load( "res://Icons/user-solid.svg" ) )
	child.set_icon_max_width( 0, icon_size )
	if glbl.dict_cfg.use_custom_color:
		child.set_custom_color( 0, actor_color.inverted() )
		child.set_icon_modulate( 0, actor_color.inverted() )
		child.set_custom_bg_color( 0, actor_color )
		child.set_custom_bg_color( 1, actor_color )
	else:
		child.set_custom_color( 0, glbl.color_theme )
		child.set_icon_modulate( 0, glbl.color_theme )
		child.clear_custom_bg_color( 0 )
		child.clear_custom_bg_color( 1 )

	var sub_label = dict_tree.create_item(child)
	sub_label.set_text( 0, "Label")
	sub_label.set_text( 1, glbl.dict_chr[actor]["label"])
	sub_label.set_icon( 0, load( "res://Icons/tag-solid.svg" ) )
	sub_label.set_icon_max_width( 0, icon_size )

	if glbl.dict_cfg.use_portraits:
		var sub_expression = dict_tree.create_item( child )
		sub_expression.set_text( 0, "Expressions" )
		sub_expression.set_icon( 0, load( "res://Icons/masks-theater-solid.svg" ) )
		sub_expression.set_icon_max_width( 0, icon_size )
		for expression in glbl.dict_chr[actor]["expressions"].keys():

			var subchild = dict_tree.create_item(sub_expression)
			subchild.set_text(0, expression)
			subchild.set_text(1, str( glbl.dict_chr[actor]["expressions"][expression] ) )
			subchild.set_text_align( 1, TreeItem.ALIGN_CENTER )

			if show_blank:
				if subchild.get_text( 0 ) == "_empty":
					sub_expression.remove_child( subchild )

	if show_blank:
		if child.get_text( 0 ) == "_BLANK":
			tree_target.remove_child(child)



func _on_BrowseDict_pressed():
	if glbl.current_dict == null:
		$BrowseDict.popup_centered()
		$DimBG.visible = true
	else:
		glbl.current_dict = null
		dict_stat_hint.text = "No global dictionary selected"
		dict_tree.clear()
		log_start( "Removed current character's dictionary" )

func _on_BrowsePortrait_pressed():
	if glbl.current_portrait == null:
		$BrowseImg.popup_centered()
		$DimBG.visible = true
	else:
		$TextureRect.texture = null
		img_stat_hint.text = "No portrait sprite selected"
		glbl.current_portrait = null
		log_start( "Removed current character's portrait" )


func _dimmed_popup_hide():
	$DimBG.visible = false


var log_msg = {
	"dict_empty"				: "[color=#ff0000]Failed to parse dict.:[/color] Empty dictionary",
	"dict_invalid"				: "[color=#ff0000]Failed to load file:[/color] Invalid character's dictionary",

	"dict_config_missing"		: "[color=#ff0000]Failed to parse dict.:[/color] Missing config.",
	"dict_config_repair"		: "Attempting repair: Setting up default config. in dictionary...",


	"dict_actor_blank_expr"		: "[color=#ff0000]Failed to parse dict.:[/color] Blank \"expression\" key on character \"",
	"dict_actor_missing_expr"	: "[color=#ff0000]Failed to parse dict.:[/color] Missing \"expression\" key on character \"",
	"dict_actor_blank_label"	: "[color=#ff0000]Failed to parse dict.:[/color] Blank \"label\" key on character \"",
	"dict_actor_missing_label"	: "[color=#ff0000]Failed to parse dict.:[/color] Missing \"label\" key on character \"",

	"dict_blank_actor"				: "[color=#ff0000]Failed to parse dict.:[/color] Blank character \"",
	"dict_blank_global_actor"		: "[color=#ff0000]Failed to parse dict.:[/color] \"characters\" key not found",
}


func verify_dict( target ):

#	var target2cfg = target["_CONFIGS"]

	var passes = 0
	var actor_count = 0
	var expression_count = 0

	log_start( "Verifying dictionary..." )

	# Config sub-dict
	if "_CONFIG" in target.keys():
		pass

	else:
		log_start( log_msg.dict_config_missing )

		if glbl.current_settings.error_fix._config:
			log_start( log_msg.dict_config_repair )
			target["_CONFIG"] = {
				"use_portraits"	: true,
				"use_custom_color"	: false,
				"use_custom_speed"	: false,
				"portrait_size_px"	: [400,400],
				"portrait_size_grid": [4,2],
			}

		else:
			passes -= 1



	# Characters sub-dict
	if "characters" in target.keys():

		var target2chr = target["characters"]
		print( target2chr )

		if target2chr is Dictionary:

			if target2chr.empty():
				passes -= 1
				log_start( log_msg.dict_empty )

			else:
				for actors in target2chr.keys():
					actor_count += 1
					if target2chr[actors] is Dictionary:

						print( target2chr[actors].keys() )

						if "expressions" in target2chr[actors].keys():
							if ( !target2chr[actors]["expressions"].empty() or !target2chr[actors]["expressions"] is Dictionary):
								for faces in target2chr[actors]["expressions"]:
									expression_count += 1

							else:
								passes -= 1
								log_start( log_msg.dict_actor_blank_expr + str( actors ) + "\"" )
						else:
							passes -= 1
							log_start( log_msg.dict_actor_missing_expr + str( actors ) + "\"" )


						if "label" in target2chr[actors].keys():
							if ( !target2chr[actors]["label"].empty() ):
								pass

							else:
								passes -= 1
								log_start( log_msg.dict_actor_blank_label + str( actors ) + "\"" )
						else:
							passes -= 1
							log_start( log_msg.dict_actor_missing_label + str( actors ) + "\"" )

					else:
						passes -= 1
						log_start( log_msg.dict_blank_actor + str( actors ) + "\"" )
		else:
			passes -= 1
			log_start( log_msg.dict_invalid )

		if passes == 0:
			log_start( "[color=#61ecf0]Dictionary verified:[/color] " + "[" + str( dict_filename ) + "] "  + str( actor_count ) + " Actors, " + str( expression_count ) + " Expressions, " )

			glbl.current_dict = target
			dict_stat_hint.text = "[" + str( dict_filename ) + "] " + str( actor_count ) + " Characters, " + str( expression_count ) + " Expressions, "

			img_browse_btn.get_parent().get_node("Use").set_pressed( glbl.current_dict._CONFIG.use_portraits )
			config_files.get_node("Color/Use").set_pressed( glbl.current_dict._CONFIG.use_custom_color )
			config_files.get_node("Speed/Use").set_pressed( glbl.current_dict._CONFIG.use_custom_speed )

			glbl.panel_dictionary.dict_cfg_use_portraits.pressed = glbl.current_dict._CONFIG.use_portraits
			glbl.panel_dictionary.dict_cfg_use_col.pressed = glbl.current_dict._CONFIG.use_custom_color
			glbl.panel_dictionary.dict_cfg_use_spd.pressed = glbl.current_dict._CONFIG.use_custom_speed

			glbl.portrait_grid_size = Vector2(
				glbl.current_dict._CONFIG.portrait_size_grid[0],
				glbl.current_dict._CONFIG.portrait_size_grid[1]
			)
			glbl.portrait_chr_size = Vector2(
				glbl.current_dict._CONFIG.portrait_size_px[0],
				glbl.current_dict._CONFIG.portrait_size_px[1]
			)

			dict_filepath = glbl.dict_filepath
			dict_filename = glbl.dict_filename
			glbl.set_dict_properties()

			glbl.panel_dictionary.dict_config_panel.get_node("PortraitConfig/Column/Value").value		= glbl.current_dict._CONFIG.portrait_size_grid[0]
			glbl.panel_dictionary.dict_config_panel.get_node("PortraitConfig/Row/Value").value			= glbl.current_dict._CONFIG.portrait_size_grid[1]
			glbl.panel_dictionary.dict_config_panel.get_node("PortraitConfig/Width/Value").value		= glbl.current_dict._CONFIG.portrait_size_px[0] 
			glbl.panel_dictionary.dict_config_panel.get_node("PortraitConfig/Height/Value").value		= glbl.current_dict._CONFIG.portrait_size_px[1]

			_build_dict_tree()

	else:
		log_start( log_msg.dict_blank_global_actor )

var dict_filepath = ""
var dict_filename = ""
func _on_BrowseDict_file_selected(path):
	print( path )
	var filewww = File.new()
	filewww.open( path , File.READ )

	print("####### get_as_text()")
	print( filewww.get_as_text() )

	glbl.dict_filepath = str( path )
	dict_filename = glbl.get_res_filename( path )

	var output_ = str2var( filewww.get_as_text() )

	filewww.close()
	dict_filepath = path

	print( typeof(output_) )

	if output_ is Dictionary:
		verify_dict( output_ )
	else:
		log_start( log_msg.dict_invalid )

func _on_NewDict_file_selected(_path):
	pass # Replace with function body.




func verify_img( target ):
	glbl.current_portrait = target
	glbl.get_portrait_properties()
	$TextureRect.texture = glbl.current_portrait


var img_filepath = ""
var img_filename = ""
func _on_BrowseImg_file_selected(path):
	img_filepath = path
	print( path )
	var filewww = File.new()
	filewww.open( path , File.READ )

	log_start( "Loading portrait..." )
	var ImegTex = ImageTexture.new()
	var Imeg = Image.new()
	img_filename = glbl.get_res_filename( path )
	Imeg.load( path )
	log_start( "[color=#61ecf0]Portrait loaded:[/color] " + "[" + str(img_filename) + "] " +
		"width:" + str( Imeg.get_width() ) +
		"px , height:" + str( Imeg.get_height() ) + "px"
		)
	ImegTex.create_from_image( Imeg )
	img_stat_hint.text = "[" + str( img_filename ) + "] " + "width:" + str( Imeg.get_width() ) + "px , height:" + str( Imeg.get_height() ) + "px"

	filewww.close()

	verify_img( ImegTex )



func start_editor():
	OS.set_window_maximized(true)
	$MainEditor.show()



func _on_CustomColor_Button_pressed():
#	config_files.get_node("Color/Use").pressed = !config_files.get_node("Color/Use").pressed
	config_files.get_node("Color/Use").pressed = config_files.get_node("Color/Button").pressed
func _on_CustomSpeed_Button_pressed():
#	config_files.get_node("Speed/Use").pressed = !config_files.get_node("Speed/Use").pressed
	config_files.get_node("Speed/Use").pressed = config_files.get_node("Speed/Button").pressed

func _on_UseCustomColor_pressed():
	pass
func _on_UseCustomSpeed_pressed():
	pass



func setcrawler_tester():
	$MainEditor/DlgSetsPanel/Main/SetCrawler._look_for( 0, "godette" )


