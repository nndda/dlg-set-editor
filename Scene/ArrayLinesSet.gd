extends Control

var loading = true
var target = ""

#										#	lord, I apologize for this abomination of a variable,
#										#	I am sure theres a better way, but am just too lazy
onready var parent_editor					= self.get_parent().get_parent().get_parent().get_parent()

onready var target_set						= parent_editor.local_set

onready var step_label						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/StepLabel")

onready var actor_portrait					= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Portrait/TextureRect")

onready var actor_name_option_in_use
onready var actor_name_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Name")
onready var actor_name_option_nop			= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/LinesEditor/ActorNoPortrait/Name")

onready var actor_expression_option			= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/Actor/Expression")

onready var speed_value_input				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Speed/ValueContainer/LineEdit")

onready var lines							= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/LinesEditor/Lines")

onready var using_quote_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/UseQuote")
#onready var using_color_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Color")
onready var using_speed_option				= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Speed")


#onready var move_node						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl")
onready var move_up							= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/MoveUp")
onready var move_down						= self.get_node("VBoxContainer/HBoxContainer/PanelContainer/RearrangeCtrl/MoveDown")
onready var delete							= self.get_node("VBoxContainer/HBoxContainer/VBoxContainer/Editor/SubOptions/Delete")

var expressions_id = {}
var names_id = {}

var data_set = false

var pass_ready = false



#	stuff for color property, idk what other approach to this
var ccolor = Color8( 0, 0, 0, 40 )
onready var cstylebox = StyleBoxFlat.new()



func get_local_line():
	return [
		target_set[ self.get_position_in_parent() * glbl.line_length ],
		target_set[ self.get_position_in_parent() * glbl.line_length + 1 ],
		target_set[ self.get_position_in_parent() * glbl.line_length + 2 ],
		target_set[ self.get_position_in_parent() * glbl.line_length + 3 ],
		target_set[ self.get_position_in_parent() * glbl.line_length + 4 ]
		]



func _ready():

	var atlas_tex = AtlasTexture.new()
	actor_portrait.texture = atlas_tex

	if glbl.dict_cfg.use_portraits:
		actor_name_option_in_use = actor_name_option
	else:
		actor_name_option_in_use = actor_name_option_nop

	actor_name_option.get_parent().visible = glbl.dict_cfg.use_portraits
	actor_name_option.get_parent().get_parent().get_node("HS2").visible = glbl.dict_cfg.use_portraits
	actor_name_option_nop.visible = !glbl.dict_cfg.use_portraits


	cstylebox.set_corner_radius_individual( 10, 0, 0, 10 )
	cstylebox.set_expand_margin_individual( 3, 10, 3, 10 )
	cstylebox.set_bg_color( ccolor )

	$"VBoxContainer/HBoxContainer/PanelContainer".add_stylebox_override( "panel", cstylebox)

	self.refresh_data()



func set_lines_var():

	# Old array format
	# Character's name
#	target_set[
#			self.get_position_in_parent() * glbl.line_length
#			] = actor_name_option_in_use.get_item_text( actor_name_option_in_use.selected )
#
#	# Character's expression/portrait
#	target_set[
#			self.get_position_in_parent() * glbl.line_length + 1
#			] = actor_expression_option.get_item_text( actor_expression_option.selected )
#
#	# Dialogue line
#	target_set[
#			self.get_position_in_parent() * glbl.line_length + 2
#			] = lines.text
#
#	# Use of quotation mark
#	target_set[
#			self.get_position_in_parent() * glbl.line_length + 3
#			] = using_quote_option.pressed
#
#	# Typing speed
#	target_set[
#			self.get_position_in_parent() * glbl.line_length + 4
#			] = float( speed_value_input.value )


	# 2D array
	# Character's name
	target_set[
		self.get_position_in_parent() ][ 0 ] = actor_name_option_in_use.get_item_text(
			actor_name_option_in_use.selected )

	# Character's expression/portrait
	target_set[
		self.get_position_in_parent() ][ 1 ] = actor_expression_option.get_item_text(
			actor_expression_option.selected )

	# Dialogue line
	target_set[
		self.get_position_in_parent() ][ 2 ] = lines.text

	# Use of quotation mark
	target_set[
		self.get_position_in_parent() ][ 3 ] = using_quote_option.pressed

	# Typing speed
	if speed_value_input.text.is_valid_float():
		target_set[
			self.get_position_in_parent() ][ 4 ] = float( speed_value_input.text)
	else:
		target_set[
			self.get_position_in_parent() ][ 4 ] = 1.0



func _process(_delta):

	if self.visible and glbl.dict_chr != null:


		if glbl.dict_cfg.use_portraits:
			actor_name_option_in_use = actor_name_option
		else:
			actor_name_option_in_use = actor_name_option_nop


		actor_name_option.get_parent().visible = glbl.dict_cfg.use_portraits
		actor_name_option.get_parent().get_parent().get_node("HS2").visible = glbl.dict_cfg.use_portraits
		actor_name_option_nop.visible = !glbl.dict_cfg.use_portraits



		step_label.text = str( self.get_position_in_parent() )



		if !loading:
			set_lines_var()
			set_portrait_img()


		else:
			if self.data_set:

				actor_name_option.select(
					actor_name_option.get_item_index(
						self.names_id[ target_set[ self.get_position_in_parent() ][ 0 ] ]
						)
					)
				self._on_Name_item_selected( actor_name_option.get_item_index( 
					actor_name_option.get_item_index(
						self.names_id[
							target_set[ self.get_position_in_parent() ][ 0 ]
							] ) ) )


				actor_name_option_nop.select(
					actor_name_option_nop.get_item_index(
						self.names_id[ target_set[ self.get_position_in_parent() ][ 0 ] ]
						)
					)
				self._on_Name_item_selected( actor_name_option_nop.get_item_index( 
					actor_name_option_nop.get_item_index(
						self.names_id[
							target_set[ self.get_position_in_parent() ][ 0 ]
							] ) ) )


				actor_expression_option.select(
					actor_expression_option.get_item_index(
						self.expressions_id[
							target_set[ self.get_position_in_parent() ][ 1 ]
							] ) )

				lines.text					= target_set[ self.get_position_in_parent() ][ 2 ]
				using_quote_option.pressed	= target_set[ self.get_position_in_parent() ][ 3 ]
				speed_value_input.text		= str( target_set[ self.get_position_in_parent() ][ 4 ] )

				loading = false



		delete.disabled = !self.get_parent().get_child_count() > 1
		move_up.disabled = !self.get_position_in_parent() != 0
		move_down.disabled = !self.get_position_in_parent() + 1 != self.get_parent().get_child_count()



		using_speed_option.disabled = !glbl.dict_cfg.use_custom_speed
		using_speed_option.visible = glbl.dict_cfg.use_custom_speed
		using_speed_option.get_node("ValueContainer").visible = using_speed_option.pressed



		if glbl.dict_cfg.use_custom_color:
			ccolor = Color8(
				glbl.dict_chr[ target_set[ self.get_position_in_parent() ][0] ].color[0],
				glbl.dict_chr[ target_set[ self.get_position_in_parent() ][0] ].color[1],
				glbl.dict_chr[ target_set[ self.get_position_in_parent() ][0] ].color[2]
			)
			move_up.get_parent().get_node("StepLabel").modulate = ccolor.inverted()

		else:
			ccolor = Color8( 0, 0, 0, 40 )
			move_up.get_parent().get_node("StepLabel").modulate = Color(1,1,1)

		cstylebox.set_bg_color( ccolor )



func refresh_data():

	if !glbl.dict_chr.empty():

		if glbl.dict_cfg.use_portraits:
			actor_portrait.texture.set_atlas( glbl.current_portrait )
#			portrait_fit_scale()

		actor_name_option.clear()
		for actor_name in ( glbl.dict_chr.keys().size() ):

			actor_name_option.add_item(
				str( glbl.dict_chr.keys()[ actor_name ] ), actor_name )
			actor_name_option_nop.add_item(
				str( glbl.dict_chr.keys()[ actor_name ] ), actor_name )

			self.names_id[ str(
					glbl.dict_chr.keys()[ actor_name ]
					) ] = actor_name

		self._on_Name_item_selected( actor_name_option.get_item_index( 0 ) )
		self._on_Name_item_selected( actor_name_option_nop.get_item_index( 0 ) )

		self.data_set = true



func _on_Name_item_selected(index):
#	if glbl.dict_chr != null:
#		if !glbl.dict_chr.empty():

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


func move_up_set():
	get_parent().move_child(
		get_parent().get_child( self.get_position_in_parent() ), 
		self.get_position_in_parent() - 1 )
func move_down_set():
	get_parent().move_child(
		get_parent().get_child( self.get_position_in_parent() ), 
		self.get_position_in_parent() + 1 )


func _on_self_visibility_changed():
	self.refresh_data()

func _on_Delete_pressed():
	# Old array
#	for _remv in range( glbl.line_length ):
#		target_set.remove( self.get_position_in_parent() * glbl.line_length )
	target_set.remove( self.get_position_in_parent() )
	self.queue_free()

func _on_Duplicate_pressed():

	# Old array format
#	if target_set.size() < self.get_position_in_parent() * glbl.line_length:
#		glbl.current_set.append_array( parent_editor.default_lines )
#
#	else:
#		glbl.current_set.insert( ( self.get_position_in_parent() * ( glbl.line_length + 0 ) ) ,
#			parent_editor.default_lines[0] )
#		glbl.current_set.insert( ( self.get_position_in_parent() * ( glbl.line_length + 0 ) ) + 0 ,
#			parent_editor.default_lines[1] )
#		glbl.current_set.insert( ( self.get_position_in_parent() * ( glbl.line_length + 0 ) ) + 0 ,
#			parent_editor.default_lines[2] )
#		glbl.current_set.insert( ( self.get_position_in_parent() * ( glbl.line_length + 0 ) ) + 0 ,
#			parent_editor.default_lines[3] )
#		glbl.current_set.insert( ( self.get_position_in_parent() * ( glbl.line_length + 0 ) ) + 0 ,
#			parent_editor.default_lines[4] )

	# 2D array
	if target_set.size() < self.get_position_in_parent():
		glbl.current_set.append( parent_editor.default_lines )

	else:
		glbl.current_set.insert( self.get_position_in_parent(),
			parent_editor.default_lines )


	parent_editor.get_node(
		"Editor/ScrollContainer/ArrayData"
		).add_child_below_node(
			self, load("res://Scene/ArrayLinesSet.tscn").instance()
			)

func _on_AddBelow_pressed():
	pass


#func _on_Speed_pressed():
#	pass # Replace with function body.
#func _on_Speed_value_changed(value):
#	pass # Replace with function body.


func _on_Expression_item_selected(_index):
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



