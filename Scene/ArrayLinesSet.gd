extends Control

var loading = true
var target = ""

onready var parent_editor					= self.get_parent().get_parent().get_parent().get_parent()
onready var target_set						= parent_editor.local_set

onready var step_label						= self.get_node("Data/Editor/PanelContainer/RearrangeCtrl/StepLabel")

onready var actor_portrait					= self.get_node("Data/Editor/Actor/Portrait/Sprite")
onready var actor_name_option				= self.get_node("Data/Editor/Actor/Name")
onready var actor_expression_option			= self.get_node("Data/Editor/Actor/Expression")

onready var lines							= self.get_node("Data/Editor/LinesEditor/Lines")

onready var using_quote_option				= self.get_node("Data/Editor/LinesEditor/SubOptions/UseQuote")

#onready var move_node						= self.get_node("Data/Editor/PanelContainer/RearrangeCtrl")
onready var move_up							= self.get_node("Data/Editor/PanelContainer/RearrangeCtrl/MoveUp")
onready var move_down						= self.get_node("Data/Editor/PanelContainer/RearrangeCtrl/MoveDown")

var expressions_id = {}
var names_id = {}

var data_set = false

var pass_ready = false

func portrait_fit_scale():
	actor_portrait.scale.x = 128 / actor_portrait.texture.get_width()
	actor_portrait.scale.y = actor_portrait.scale.x



func get_local_line():
	return [
		target_set[ self.get_position_in_parent() * 4 ],
		target_set[ self.get_position_in_parent() * 4 + 1 ],
		target_set[ self.get_position_in_parent() * 4 + 2 ],
		target_set[ self.get_position_in_parent() * 4 + 3 ]
	]



func _ready():
	portrait_fit_scale()
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
	if self.visible and glbl.current_dlg_dict != null:
		step_label.text = str( self.get_position_in_parent() )

		if !loading:
#			if glbl.current_set_use_expr:
			set_lines_var()

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

		$"Data/Editor/LinesEditor/SubOptions/Delete".disabled = !self.get_parent().get_child_count() > 1

		move_up.disabled = !self.get_position_in_parent() != 0
		move_down.disabled = !self.get_position_in_parent() + 1 != self.get_parent().get_child_count()

		actor_expression_option.visible = glbl.current_set_use_expr
		actor_portrait.visible = glbl.current_set_use_expr



func refresh_data():
	portrait_fit_scale()
	if !glbl.current_dlg_dict.empty():
		actor_name_option.clear()
		for actor_name in ( glbl.current_dlg_dict.keys().size() ):
			actor_name_option.add_item(
				str(
					glbl.current_dlg_dict.keys()[ actor_name ]
					),
				actor_name
			)

			self.names_id[ str(
					glbl.current_dlg_dict.keys()[ actor_name ]
					) ] = actor_name

		self._on_Name_item_selected( actor_name_option.get_item_index( 0 ) )
		self.data_set = true



func _on_Name_item_selected(index):
	if glbl.current_dlg_dict != null:
		if !glbl.current_dlg_dict.empty() and glbl.current_set_use_expr:

			self.expressions_id.clear()
			actor_expression_option.clear()

			for expression in (
				glbl.current_dlg_dict[ actor_name_option.get_item_text( index ) ][
					"expressions"
					].keys().size()
				):

					actor_expression_option.add_item(
						glbl.current_dlg_dict[
							actor_name_option.get_item_text( index )
							]["expressions"].keys()[ expression ],
							expression
						)

					self.expressions_id[str(glbl.current_dlg_dict[
							actor_name_option.get_item_text( index )
							]["expressions"].keys()[ expression ])] = expression


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
