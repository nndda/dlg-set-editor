extends Control

#onready var dict_tree = $EditorContainer/Main/MainEditor/GlblDictTree
onready var dict_tree = $"MainEditor/Sets_Dict/RightPanel/Characters/TabContainer/Tree/GlblDictTree"
onready var dict_raw = $"MainEditor/Sets_Dict/RightPanel/Characters/TabContainer/Raw/RawDict"

onready var log_node = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/LogContainer/Logs"

onready var dict_stat_hint = $EditorContainer/Main/UpperBar/Stats/GlobalDict
onready var img_stat_hint = $EditorContainer/Main/UpperBar/Stats/GlobalPortrait

onready var dict_browse_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/BrowseBtn/Dict/Button"
onready var img_browse_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/BrowseBtn/Portrait/Button"

onready var load_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/Templates/Load/Button"

onready var crop_arg = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/FunctionArg"

onready var tooltip_label = $"StartScreen/CenterContainer/VBoxContainer/HintTooltip/LabelText"

func _ready():
	glbl.current_dict = null
	dict_stat_hint.text = "No global dictionary selected"
	log_start( "Waiting input..." )

func log_start(message :String):
	log_node.append_bbcode( message )
	log_node.newline()

func _process(_delta):
	$StartScreen.visible = !$MainEditor.visible
	$TextureRect.visible = $StartScreen.visible

	load_btn.disabled = (
		glbl.current_dict == null or
		glbl.current_portrait == null
		)

	dict_browse_btn.get_node("../OK").visible = glbl.current_dict != null
	if glbl.current_dict != null:
		dict_browse_btn.text = " Remove dict."
		dict_browse_btn.set_pressed(true)
	else:
		dict_browse_btn.text = " Select dict."
		dict_browse_btn.set_pressed(false)

#	img_browse_btn.get_node("../OK").visible = glbl.dict_chr._CONFIG.use_portraits
	img_browse_btn.get_node("../OK").visible = glbl.current_portrait != null
	if glbl.current_portrait != null:
		img_browse_btn.text = " Remove portraits"
		img_browse_btn.set_pressed(true)
	else:
		img_browse_btn.text = " Select portraits"
		img_browse_btn.set_pressed(false)


func set_tooltiphint( messag = "" ):
	if messag != "":
		tooltip_label.text = messag
	else:
		tooltip_label.text = "nnda.itch.io"


func _build_dict_tree():

	var icon_size = 16

	dict_raw.text = var2str( glbl.current_dict )
	
#	var dict_chr = glbl.dict_chr
#	var dict_cfg

	dict_tree.set_column_title(0,"Character's Dictionary")
	dict_tree.set_columns(2)
	var root = dict_tree.create_item()
	dict_tree.set_hide_root(true)

	for actor in glbl.dict_chr.keys():
		var child = dict_tree.create_item(root)
		child.set_text( 0, actor)
		child.set_custom_color( 0, glbl.color_theme )
		child.set_icon( 0, load( "res://Icons/user-solid.svg" ) )
		child.set_icon_max_width( 0, icon_size )
		child.set_icon_modulate( 0, glbl.color_theme )

		var sub_label = dict_tree.create_item(child)
		sub_label.set_text( 0, "Label")
		sub_label.set_text( 1, glbl.dict_chr[actor]["label"])
		sub_label.set_icon( 0, load( "res://Icons/tag-solid.svg" ) )
		sub_label.set_icon_max_width( 0, icon_size )

		var sub_expression = dict_tree.create_item( child )
		sub_expression.set_text( 0, "Expressions" )
		sub_expression.set_icon( 0, load( "res://Icons/masks-theater-solid.svg" ) )
		sub_expression.set_icon_max_width( 0, icon_size )
		for expression in glbl.dict_chr[actor]["expressions"].keys():
			var subchild = dict_tree.create_item(sub_expression)
			subchild.set_text(0, expression)
			subchild.set_text(1, str( glbl.dict_chr[actor]["expressions"][expression] ) )
			subchild.set_text_align( 1, TreeItem.ALIGN_CENTER )


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
#			glbl.dict_chr = target2chr
			glbl.current_dict = target
			glbl.set_dict_properties()
			dict_stat_hint.text = "[" + str( dict_filename ) + "] " + str( actor_count ) + " Characters, " + str( expression_count ) + " Expressions, "

			crop_arg.get_node("Size/X").value = glbl.current_dict._CONFIG.portrait_size_px[0]
			crop_arg.get_node("Size/Y").value = glbl.current_dict._CONFIG.portrait_size_px[1]

			crop_arg.get_node("Gap/X").value = glbl.current_dict._CONFIG.portrait_size_grid[0]
			crop_arg.get_node("Gap/Y").value = glbl.current_dict._CONFIG.portrait_size_grid[1]

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

	dict_filename = glbl.get_res_filename( path )

	var output_ = str2var( filewww.get_as_text() )

	filewww.close()
	dict_filepath = path

	print( typeof(output_) )

	if output_ is Dictionary:
		verify_dict( output_ )
	else:
		log_start( log_msg.dict_invalid )


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

#	filewww.flush()
	verify_img( ImegTex )


func _on_Gap_value_changed(_value):
	glbl.portrait_grid_size = Vector2(
		crop_arg.get_node("Gap/X").value,
		crop_arg.get_node("Gap/Y").value
		)
	glbl.portrait_chr_size = Vector2(
		crop_arg.get_node("Size/X").value,
		crop_arg.get_node("Size/Y").value
		)


func start_editor():
	OS.set_window_maximized(true)
#	$StartScreen.visible = false
	$MainEditor.show()
