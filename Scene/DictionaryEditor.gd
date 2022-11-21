extends TabContainer

onready var dict_config_panel = $"Dictionary/Panel/Config"
onready var dict_cfg_use_portraits = dict_config_panel.get_node("use_portraits")
onready var dict_cfg_use_col = dict_config_panel.get_node("use_custom_color")
onready var dict_cfg_use_spd = dict_config_panel.get_node("use_custom_speed")

onready var dict_chr_panel = $"Dictionary/Panel/Character"
onready var actor_name_option = dict_chr_panel.get_node("Current/Options")

var names_id = {}

func refresh_data():
	if !glbl.dict_chr.empty():
		actor_name_option.clear()
		for actor_name in ( glbl.dict_chr.keys().size() ):
			actor_name_option.add_item(
				str(
					glbl.dict_chr.keys()[ actor_name ]
					),
				actor_name
				)

			self.names_id[ str(
					glbl.dict_chr.keys()[ actor_name ]
					) ] = actor_name

#		self._on_Name_item_selected( actor_name_option.get_item_index( 0 ) )

#			crop_arg.get_node("Size/X").value = glbl.current_dict._CONFIG.portrait_size_px[0]
#			crop_arg.get_node("Size/Y").value = glbl.current_dict._CONFIG.portrait_size_px[1]

#			crop_arg.get_node("Gap/X").value = glbl.current_dict._CONFIG.portrait_size_grid[0]
#			crop_arg.get_node("Gap/Y").value = glbl.current_dict._CONFIG.portrait_size_grid[1]
func _ready():
	glbl.panel_dictionary = self
func _process(_delta):
	pass
#	actor_name_option.get_parent().get_node("Delete").disabled = actor_name_option.get_item_text( actor_name_option.selected ) == "_BLANK"


func _on_CharacterEditor_visibility_changed():
	refresh_data()


func _on_DictionaryPanel_tab_selected(tab):
	pass # Replace with function body.

func UpdateDictContent():
	glbl.main_app._build_dict_tree(
		get_node("Dictionary/Panel/Content/Control/ShowCfg").pressed,
		!get_node("Dictionary/Panel/Content/Control/ShowBlank").pressed
	)

func _on_DictContentView_visibility_changed():
	UpdateDictContent()
func _on_View_item_selected(index):
	glbl.main_app.dict_raw.visible = index == 1
	get_node("Dictionary/Panel/Content/Control/ShowCfg").visible = !glbl.main_app.dict_tree.visible
	get_node("Dictionary/Panel/Content/Control/ShowBlank").visible = !glbl.main_app.dict_tree.visible

func _on_use_portraits_pressed():
	glbl.dict_cfg.use_portraits = dict_cfg_use_portraits.pressed
func _on_use_custom_color_pressed():
	glbl.dict_cfg.use_custom_color = dict_cfg_use_col.pressed
func _on_use_custom_speed_pressed():
	glbl.dict_cfg.use_custom_speed = dict_cfg_use_spd.pressed


func _crop_portrait_Value_changed():
	glbl.dict_cfg.portrait_size_grid[0] = dict_config_panel.get_node("PortraitConfig/Column/Value").value
	glbl.dict_cfg.portrait_size_grid[1] = dict_config_panel.get_node("PortraitConfig/Row/Value").value
	glbl.dict_cfg.portrait_size_px[0] = dict_config_panel.get_node("PortraitConfig/Width/Value").value
	glbl.dict_cfg.portrait_size_px[1] = dict_config_panel.get_node("PortraitConfig/Height/Value").value


