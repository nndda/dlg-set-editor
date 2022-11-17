extends Control

#onready var dict_tree = $EditorContainer/Main/MainEditor/GlblDictTree
onready var dict_tree = $"MainEditor/Sets_Dict/RightPanel/Actors/TabContainer/Tree/GlblDictTree"
onready var dict_raw = $"MainEditor/Sets_Dict/RightPanel/Actors/TabContainer/Raw/RawDict"

onready var log_node = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/LogContainer/Logs"

onready var dict_stat_hint = $EditorContainer/Main/UpperBar/Stats/GlobalDict
onready var img_stat_hint = $EditorContainer/Main/UpperBar/Stats/GlobalPortrait

onready var dict_browse_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/BrowseBtn/Dict/Button"
onready var img_browse_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/BrowseBtn/Portrait/Button"

onready var load_btn = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/Templates/Load/Button"

onready var crop_arg = $"StartScreen/CenterContainer/VBoxContainer/TabContainer/Sets Editor/Inputs/FunctionArg"

onready var tooltip_label = $"StartScreen/CenterContainer/VBoxContainer/HintTooltip/LabelText"

func _ready():
	glbl.current_dlg_dict = null
	dict_stat_hint.text = "No global dictionary selected"
	log_start( "Waiting input..." )

func log_start(message :String):
	log_node.append_bbcode( message )
	log_node.newline()

func _process(_delta):
	$StartScreen.visible = !$MainEditor.visible
	$TextureRect.visible = $StartScreen.visible

	load_btn.disabled = (
		glbl.current_dlg_dict == null or
		glbl.current_expr == null
		)

	dict_browse_btn.get_node("../OK").visible = glbl.current_dlg_dict != null
	if glbl.current_dlg_dict != null:
		dict_browse_btn.text = " Remove dict."
		dict_browse_btn.set_pressed(true)
	else:
		dict_browse_btn.text = " Select dict."
		dict_browse_btn.set_pressed(false)

	img_browse_btn.get_node("../OK").visible = glbl.current_expr != null
	if glbl.current_expr != null:
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
	
	
	dict_raw.text = var2str( glbl.current_dlg_dict )

	dict_tree.set_column_title(0,"Actor's Dictionary")
	dict_tree.set_columns(2)
	var root = dict_tree.create_item()
	dict_tree.set_hide_root(true)

	for actor in glbl.current_dlg_dict.keys():
		var child = dict_tree.create_item(root)
		child.set_text( 0, actor)
		child.set_custom_color( 0, glbl.color_theme )
		child.set_icon( 0, load( "res://Icons/user-solid.svg" ) )
		child.set_icon_max_width( 0, icon_size )
		child.set_icon_modulate( 0, glbl.color_theme )

		var sub_label = dict_tree.create_item(child)
		sub_label.set_text( 0, "Label")
		sub_label.set_text( 1, glbl.current_dlg_dict[actor]["label"])
		sub_label.set_icon( 0, load( "res://Icons/tag-solid.svg" ) )
		sub_label.set_icon_max_width( 0, icon_size )

		var sub_expression = dict_tree.create_item( child )
		sub_expression.set_text( 0, "Expressions" )
		sub_expression.set_icon( 0, load( "res://Icons/masks-theater-solid.svg" ) )
		sub_expression.set_icon_max_width( 0, icon_size )
		for expression in glbl.current_dlg_dict[actor]["expressions"].keys():
			var subchild = dict_tree.create_item(sub_expression)
			subchild.set_text(0, expression)
			subchild.set_text(1, str( glbl.current_dlg_dict[actor]["expressions"][expression] ) )
#			subchild.set_text(2, str( glbl.current_dlg_dict[actor]["expressions"][expression][1] ) )
			subchild.set_text_align( 1, TreeItem.ALIGN_CENTER )
#			subchild.set_text_align( 2, TreeItem.ALIGN_CENTER )

#			print( typeof( 
#			glbl.portrait_revar( glbl.current_dlg_dict[actor]["expressions"][expression] ) ) )


func _on_BrowseDict_pressed():
	if glbl.current_dlg_dict == null:
		$BrowseDict.popup_centered()
		$DimBG.visible = true
	else:
		glbl.current_dlg_dict = null
		dict_stat_hint.text = "No global dictionary selected"
		dict_tree.clear()
		log_start( "Removed current actor's dictionary" )

func _on_BrowsePortrait_pressed():
	if glbl.current_expr == null:
		$BrowseImg.popup_centered()
		$DimBG.visible = true
	else:
		$TextureRect.texture = null
		img_stat_hint.text = "No portrait sprite selected"
		glbl.current_expr = null
		log_start( "Removed current actor's portrait" )

#func _on_BrowseScript_pressed():
#	$BrowseScript.popup_centered()
#	$DimBG.visible = true


func _dimmed_popup_hide():
	$DimBG.visible = false


var log_msg = {
	"dict_empty"				: "[color=#ff0000]Failed to parse dict.:[/color] Empty dictionary",
	"dict_invalid"				: "[color=#ff0000]Failed to load file:[/color] Invalid actor's dictionary",

	"dict_actor_blank_expr"		: "[color=#ff0000]Failed to parse dict.:[/color] Blank \"expression\" key on actor \"",
	"dict_actor_missing_expr"	: "[color=#ff0000]Failed to parse dict.:[/color] Missing \"expression\" key on actor \"",
	"dict_actor_blank_label"	: "[color=#ff0000]Failed to parse dict.:[/color] Blank \"label\" key on actor \"",
	"dict_actor_missing_label"	: "[color=#ff0000]Failed to parse dict.:[/color] Missing \"label\" key on actor \"",
	
	"dict_blank_actor"				: "[color=#ff0000]Failed to parse dict.:[/color] Blank actor \"",
}


func verify_dict( target ):

	var passes = 0
	var actor_count = 0
	var expression_count = 0

	log_start( "Verifying dictionary..." )
	if target is Dictionary:

		if target.empty():
			passes -= 1
			log_start( log_msg.dict_empty )

		else:
			for actors in target.keys():
				actor_count += 1
				if target[actors] is Dictionary:

					print( target[actors].keys() )


					if "expressions" in target[actors].keys():
						if ( !target[actors]["expressions"].empty() or !target[actors]["expressions"] is Dictionary):
							for faces in target[actors]["expressions"]:
								expression_count += 1

						else:
							passes -= 1
							log_start( log_msg.dict_actor_blank_expr + str( actors ) + "\"" )
					else:
						passes -= 1
						log_start( log_msg.dict_actor_missing_expr + str( actors ) + "\"" )


					if "label" in target[actors].keys():
						if ( !target[actors]["label"].empty() ):
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
		glbl.current_dlg_dict = target
		dict_stat_hint.text = "[" + str( dict_filename ) + "] " + str( actor_count ) + " Actors, " + str( expression_count ) + " Expressions, "
		_build_dict_tree()

var dict_filepath = ""
var dict_filename = ""
func _on_BrowseDict_file_selected(path):
	print( path )
	var filewww = File.new()
	filewww.open( path , File.READ )
	print("####### get_as_text()")
	print( filewww.get_as_text() )
#	print( path.right( path.find_last( "/" ) + 1 ) )
	dict_filename = glbl.get_res_filename( path )
	var output_ = str2var( filewww.get_as_text() )
	filewww.close()
	dict_filepath = path
#	filewww.flush()
	verify_dict( output_ )


func verify_img( target ):
	glbl.current_expr = target
	$TextureRect.texture = glbl.current_expr

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
	glbl.portrait_crop_rect = Rect2(
		crop_arg.get_node("Size/X").value,
		crop_arg.get_node("Size/Y").value,

		crop_arg.get_node("Gap/X").value,
		crop_arg.get_node("Gap/Y").value
	)


func start_editor():
	OS.set_window_maximized(true)
#	$StartScreen.visible = false
	$MainEditor.show()
