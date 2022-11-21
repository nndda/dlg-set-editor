extends Control

var loading = true
var target = ""

#										#	lord, I apologize for this abomination of a variable,
#										#	I am sure theres a better way, but am just too lazy
onready var parent_editor					= self.get_parent().get_parent().get_parent().get_parent()

onready var target_set						= parent_editor.local_set

onready var step_label						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/StepLabel")

onready var actor_portrait					= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Portrait/TextureRect")
onready var actor_name_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Name")
onready var actor_expression_option			= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Expression")

onready var lines							= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/LinesEditor/Lines")

onready var using_quote_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/UseQuote")
onready var using_color_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Color")
onready var using_speed_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Speed")


#onready var move_node						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl")
onready var move_up							= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/MoveUp")
onready var move_down						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/MoveDown")
onready var delete							= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Delete")

var expressions_id = {}
var names_id = {}

var data_set = false

var pass_ready = false

func portrait_fit_scale():
#	actor_portrait.scale.x = 128 / actor_portrait.texture.get_width()
#	actor_portrait.scale.y = actor_portrait.scale.x
	pass



func get_local_line():
	return [
		target_set[ self.get_position_in_parent() * 4 ],
		target_set[ self.get_position_in_parent() * 4 + 1 ],
		target_set[ self.get_position_in_parent() * 4 + 2 ],
		target_set[ self.get_position_in_parent() * 4 + 3 ]
		]



func _ready():
	var atlas_tex = AtlasTexture.new()
	actor_portrait.texture = atlas_tex
#	portrait_fit_scale()
	self.refresh_data()



func set_lines_var():
		target_set[
				self.get_position_in_parent() * 4
				] = actor_name_option.get_item_text( actor_name_option.selected )
		target_set[
				self.get_position_in_parent() * 4 + 1
				] = actor_expression_option.get_item_text( actor_expression_option.selected )
		target_set[
				self.get_position_in_parent() * 4 + 2
				] = lines.text
		target_set[
				self.get_position_in_parent() * 4 + 3
				] = using_quote_option.pressed


func _process(_delta):


#	if self.visible and glbl.dict_chr != null:
	if self.visible and glbl.current_dict != null:
		step_label.text = str( self.get_position_in_parent() )

		if !loading:
#			if glbl.current_set_use_expr:
			set_lines_var()
			set_portrait_img()

		else:
			if self.data_set:
				actor_name_option.select(
					actor_name_option.get_item_index(
						self.names_id[ target_set[ self.get_position_in_parent() * 4 ] ]
						)
					)
				self._on_Name_item_selected( actor_name_option.get_item_index( 
					actor_name_option.get_item_index(
						self.names_id[
							target_set[ self.get_position_in_parent() * 4 ]
							] ) ) )
				actor_expression_option.select(
					actor_expression_option.get_item_index(
						self.expressions_id[
							target_set[ self.get_position_in_parent() * 4 + 1 ]
							] ) )
				lines.text												= target_set[ self.get_position_in_parent() * 4 + 2 ]
				using_quote_option.pressed								= target_set[ self.get_position_in_parent() * 4 + 3 ]

				loading = false



		delete.disabled = !self.get_parent().get_child_count() > 1
		move_up.disabled = !self.get_position_in_parent() != 0
		move_down.disabled = !self.get_position_in_parent() + 1 != self.get_parent().get_child_count()



		actor_name_option.get_parent().visible = glbl.dict_cfg.use_portraits
		actor_name_option.get_parent().get_parent().get_node("HS2").visible = glbl.dict_cfg.use_portraits

		using_color_option.disabled = glbl.dict_cfg.use_custom_color
		using_color_option.visible = glbl.dict_cfg.use_custom_color

		using_speed_option.disabled = glbl.dict_cfg.use_custom_speed
		using_speed_option.visible = glbl.dict_cfg.use_custom_speed



#		actor_expression_option.visible = glbl.current_set_use_expr
#		actor_portrait.visible = glbl.current_set_use_expr
#		actor_expression_option.visible = glbl.current_set_use_expr
#		actor_portrait.visible = glbl.current_set_use_expr



func refresh_data():
	actor_portrait.texture.set_atlas( glbl.current_portrait )
	portrait_fit_scale()
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

		self._on_Name_item_selected( actor_name_option.get_item_index( 0 ) )
		self.data_set = true
#	print( glbl.portrait_crop( 0, 0 ) )



func _on_Name_item_selected(index):
	if glbl.dict_chr != null:
		if !glbl.dict_chr.empty():

			if glbl.dict_cfg.use_portraits:

				self.expressions_id.clear()
				actor_expression_option.clear()

				for expression in (
					glbl.dict_chr[ actor_name_option.get_item_text( index ) ][
						"expressions"
						].keys().size()
					):

						actor_expression_option.add_item(
							glbl.dict_chr[
								actor_name_option.get_item_text( index )
								]["expressions"].keys()[ expression ],
								expression
							)

						self.expressions_id[str(glbl.dict_chr[
								actor_name_option.get_item_text( index )
								]["expressions"].keys()[ expression ])] = expression

	#			emit_signal("_on_Expression_item_selected")
	#			set_portrait_img()


func move_up_set():
	get_parent().move_child(
		get_parent().get_child( self.get_position_in_parent() ), 
		self.get_position_in_parent() - 1
	)
func move_down_set():
	get_parent().move_child(
		get_parent().get_child( self.get_position_in_parent() ), 
		self.get_position_in_parent() + 1
	)

func _on_self_visibility_changed():
	self.refresh_data()

func _on_Delete_pressed():
	for _remv in range( 4 ):
		target_set.remove( self.get_position_in_parent() * 4 )
	self.queue_free()

func _on_Duplicate_pressed():
	if target_set.size() < self.get_position_in_parent() * 4:
		glbl.current_set.append_array( parent_editor.default_lines )

	else:
		glbl.current_set.insert( ( self.get_position_in_parent() * ( 4 + 0 ) ) ,
			parent_editor.default_lines[0] )
		glbl.current_set.insert( ( self.get_position_in_parent() * ( 4 + 0 ) ) + 0 ,
			parent_editor.default_lines[1] )
		glbl.current_set.insert( ( self.get_position_in_parent() * ( 4 + 0 ) ) + 0 ,
			parent_editor.default_lines[2] )
		glbl.current_set.insert( ( self.get_position_in_parent() * ( 4 + 0 ) ) + 0 ,
			parent_editor.default_lines[3])

	parent_editor.get_node(
		"Editor/ScrollContainer/ArrayData"
		).add_child_below_node(
			self, load("res://Scene/ArrayLinesSet.tscn").instance()
			)

func _on_AddBelow_pressed():
	pass


func _on_Expression_item_selected(_index):
	# Setting portrait
	self.set_portrait_img()
func set_portrait_img():

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

