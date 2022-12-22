extends TabContainer

#	I want to time travel and punch my past self in the face
#	who thought storing all main function of the dict. editor in one script is a good idea



#	Dictionary Editor

onready var dict_config_panel = $"Dictionary/Panel/Config"
onready var dict_cfg_use_portraits = dict_config_panel.get_node("use_portraits")
onready var dict_cfg_use_col = dict_config_panel.get_node("use_custom_color")
onready var dict_cfg_use_spd = dict_config_panel.get_node("use_custom_speed")

onready var dict_chr_panel					= $"Dictionary/Panel/Character/Item"
onready var actor_name_label				= dict_chr_panel.get_node("Name")
onready var actor_name_edit					= dict_chr_panel.get_node("CurrentChr/HBoxContainer/NameEdit")
onready var actor_name_option				= dict_chr_panel.get_node("Current/Options")
onready var actor_expression_option			= dict_chr_panel.get_node("CurrentExpressions/Current/Options")

onready var actor_portrait					= dict_chr_panel.get_node("Portrait/TextureRect")

onready var actor_color						= dict_chr_panel.get_node("CurrentChr/HBoxContainer/ColorPickerButton")

var expressions_id = {}
var names_id = {}


#################################################
#		ONLY USE dict_chr AND dict_cfg			#
#		AND NOT DIRECTLY TO current_dict		#
#################################################


func refresh_data():
	if !glbl.dict_chr.empty() and !glbl.dict_cfg.empty():

		dict_cfg_use_portraits.disabled = glbl.current_portrait == null
		dict_cfg_use_portraits.get_node("../use_portraits_warn").visible = glbl.current_portrait == null
		dict_chr_panel.get_node("CurrentExpressions").visible = glbl.dict_cfg.use_portraits

		actor_name_option.clear()
		for actor_name in ( glbl.dict_chr.keys().size() ):

#			if str( glbl.dict_chr.keys()[ actor_name ] ) != "_BLANK":

			actor_name_option.add_item(
				str(
					glbl.dict_chr.keys()[ actor_name ]
					),
				actor_name
				)

			self.names_id[ str(
					glbl.dict_chr.keys()[ actor_name ]
					) ] = actor_name

		actor_name_option.select( actor_name_option.selected )
		dict_chr_panel.get_node("CurrentChr/LineEdit").set_text( glbl.dict_chr[ 
			actor_name_option.get_item_text( actor_name_option.selected ) ].label )

		actor_name_option.select( 0 )

		actor_name_label.visible = glbl.dict_cfg.use_portraits
		actor_portrait.get_parent().visible = glbl.dict_cfg.use_portraits

		actor_name_label.text = str( glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ][ "label" ] )
		actor_name_edit.text = str( glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ][ "label" ] )

		actor_color.visible = glbl.dict_cfg.use_custom_color
		if glbl.dict_cfg.use_portraits:
			actor_portrait.texture.set_atlas( glbl.current_portrait )
#			if actor_expression_option.get_item_count() > 0:
#				self.set_portrait_img()
		if glbl.dict_cfg.use_custom_color:
			actor_color.color = Color8(
				glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 0 ],
				glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 1 ],
				glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 2 ]
				)



func _ready():
	glbl.panel_dictionary = self
	var atlas_tex = AtlasTexture.new()
	actor_portrait.texture = atlas_tex

func _process(_delta):
	if self.visible:
		if actor_name_option.get_item_count() > 0:
			var blank_selected = actor_name_option.get_item_text( actor_name_option.selected ) == "_BLANK"
			dict_chr_panel.get_node("IsBlank").visible = blank_selected
			dict_chr_panel.get_node("Name").visible = !blank_selected
			dict_chr_panel.get_node("Portrait").visible = !blank_selected
			dict_chr_panel.get_node("CurrentChr").visible = !blank_selected
#			dict_chr_panel.get_node("CustomColor").visible = !blank_selected
			dict_chr_panel.get_node("CurrentExpressions").visible = !blank_selected
			dict_chr_panel.get_node("ControlChanges").visible = !blank_selected


func _on_CharacterEditor_visibility_changed():
	refresh_data()

func _on_DictionaryPanel_tab_selected(_tab):
	pass # Replace with function body.

func UpdateDictContent():
	glbl.main_app._build_dict_tree(
		get_node("Dictionary/Panel/Content/Control/ShowCfg").pressed,
		!get_node("Dictionary/Panel/Content/Control/ShowBlank").pressed
		)


func _on_DictContentView_visibility_changed():
	UpdateDictContent()
func _on_DictConfig_visibility_changed():
	dict_cfg_use_portraits.pressed = glbl.dict_cfg.use_portraits
	if !glbl.dict_cfg.empty() and dict_config_panel.visible:
		glbl.dict_cfg.portrait_size_grid[0] = dict_config_panel.get_node("PortraitConfig/Column/Value").value
		glbl.dict_cfg.portrait_size_grid[1] = dict_config_panel.get_node("PortraitConfig/Row/Value").value
		glbl.dict_cfg.portrait_size_px[0] = dict_config_panel.get_node("PortraitConfig/Width/Value").value
		glbl.dict_cfg.portrait_size_px[1] = dict_config_panel.get_node("PortraitConfig/Height/Value").value
func _on_View_item_selected(index):
	glbl.main_app.dict_raw.visible = index == 1
	get_node("Dictionary/Panel/Content/Control/ShowCfg").visible = !glbl.main_app.dict_tree.visible
	get_node("Dictionary/Panel/Content/Control/ShowBlank").visible = !glbl.main_app.dict_tree.visible


func _on_use_portraits_pressed():
	glbl.dict_cfg.use_portraits = dict_cfg_use_portraits.pressed
	dict_config_panel.get_node("PortraitConfig").visible = glbl.dict_cfg.use_portraits
func _on_use_custom_color_pressed():
	glbl.dict_cfg.use_custom_color = dict_cfg_use_col.pressed
func _on_use_custom_speed_pressed():
	glbl.dict_cfg.use_custom_speed = dict_cfg_use_spd.pressed


func _crop_portrait_Value_changed(_value):
	if !glbl.dict_cfg.empty() and dict_config_panel.visible:
		glbl.dict_cfg.portrait_size_grid[0] = dict_config_panel.get_node("PortraitConfig/Column/Value").value
		glbl.dict_cfg.portrait_size_grid[1] = dict_config_panel.get_node("PortraitConfig/Row/Value").value
		glbl.dict_cfg.portrait_size_px[0] = dict_config_panel.get_node("PortraitConfig/Width/Value").value
		glbl.dict_cfg.portrait_size_px[1] = dict_config_panel.get_node("PortraitConfig/Height/Value").value


#	Character-specific configurations

func _on_ColorPickerButton_color_changed(color):
	glbl.dict_chr[ 
		actor_name_option.get_item_text( actor_name_option.selected ) ].color = [
			color.r8, color.g8, color.b8 ]


func _on_Chr_item_selected(index):
	actor_name_label.text = str( glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ][ "label" ] )
	actor_name_edit.text = str( glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ][ "label" ] )

	if glbl.dict_cfg.use_portraits:

		self.expressions_id.clear()
		actor_expression_option.clear()

		for expression in (
			glbl.dict_chr[ actor_name_option.get_item_text( index ) ][
				"expressions"
				].keys().size()
				):

				if glbl.dict_chr[
						actor_name_option.get_item_text( index )
						]["expressions"].keys()[ expression ] != "_empty":

					actor_expression_option.add_item(
						glbl.dict_chr[
							actor_name_option.get_item_text( index )
							]["expressions"].keys()[ expression ],
							expression
							)

					self.expressions_id[str(glbl.dict_chr[
							actor_name_option.get_item_text( index )
							]["expressions"].keys()[ expression ])] = expression

		self.set_portrait_img()
#		actor_expression_option.select(0)

	if glbl.dict_cfg.use_custom_color:
		actor_color.color = Color8(
			glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 0 ],
			glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 1 ],
			glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ].color[ 2 ]
			)


func _on_ChrExpressions_item_selected(index):
	self.set_portrait_img()
func set_portrait_img():

	if actor_name_option.get_item_text( actor_name_option.selected ) != "_BLANK":
		if actor_expression_option.get_item_text( actor_expression_option.selected ) != "_empty":

			actor_portrait.texture.set_region( glbl.portrait_crop(

				glbl.dict_chr[
					actor_name_option.get_item_text( actor_name_option.selected ) ]["expressions"][
						actor_expression_option.get_item_text( actor_expression_option.selected ) ][0],

				glbl.dict_chr[
					actor_name_option.get_item_text( actor_name_option.selected ) ]["expressions"][
						actor_expression_option.get_item_text( actor_expression_option.selected ) ][1]

				) )

		else:
			actor_portrait.texture.set_region( Rect2(0,0,0,0) )





func _on_Save_pressed():
	glbl.save_dict_properties()

func _on_CHR_Delete_pressed():

	if glbl.set_crawler.check_character(
		str( actor_name_option.get_item_text( actor_name_option.selected ) )
		).empty():
			$"../../../PopUpContainer/ConfirmDeleteCHR".popup_centered()

	else:
		glbl.set_crawler_popup.get_node("Panel/VBoxContainer/Label").text = "Unable to remove " + str( actor_name_option.get_item_text( actor_name_option.selected ) )
		glbl.set_crawler_popup.get_node("Panel/VBoxContainer/ScrollContainer/Logs").add_log(
			glbl.set_crawler.check_character(
				str( actor_name_option.get_item_text( actor_name_option.selected ) )
			)
		)
		glbl.set_crawler_popup.popup_centered()

func _on_ConfirmDeleteCHR_confirmed():
	glbl.dict_chr.erase( str( actor_name_option.get_item_text( actor_name_option.selected ) ) )
	self.refresh_data()


func _on_Actor_NameEdit_text_changed(new_text):
	glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ]["label"] = str( new_text )
	actor_name_label.text = str( glbl.dict_chr[ actor_name_option.get_item_text( actor_name_option.selected ) ][ "label" ] )


func _on_CHR_ApplyChange_pressed():
	glbl.save_dict_properties()


