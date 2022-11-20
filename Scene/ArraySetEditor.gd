extends PanelContainer

export(Array) var local_set = []
var target_set_file : String

var default_lines = []

func update_set_lines():
	if !glbl.dict_chr.empty():
		default_lines = glbl.get_default_lines()
	glbl.current_set = local_set
#	load_set()

func save_set():
	print( "Saving set to : " + str( glbl.current_set_fullpath ) )
	var save_file = File.new()
	save_file.open( glbl.current_set_fullpath, File.WRITE )
	save_file.store_string( var2str( glbl.current_set ) )
	save_file.close()

func load_set():
	print( "Loading set" )
	get_node("Editor/VBoxContainer/Marker/Label").text = glbl.current_set_filename

	target_set_file = glbl.current_set_fullpath
	local_set = glbl.current_set

	for chd_c in get_node("Editor/ScrollContainer/ArrayData").get_children():
		chd_c.queue_free()

	if !local_set.empty():
		if local_set.size() >= 4:
			for step_count in local_set.size() / 4:
				get_node("Editor/ScrollContainer/ArrayData").add_child( load("res://Scene/ArrayLinesSet.tscn").instance() )
	else:
		pass


func _ready():
	if local_set.empty():
		pass
	else:
		if local_set.size() >= 4:
			for step_count in local_set.size() / 4:
				get_node("Editor/ScrollContainer/ArrayData").add_child( load("res://Scene/ArrayLinesSet.tscn").instance() )

func _process(_delta):
	for btns in get_node("Editor/VBoxContainer/Set").get_children():
		if btns is Button:
			btns.disabled = !( glbl.current_set.size() >= 4 )
	$"Editor/Hints".visible = $"Editor/ScrollContainer/ArrayData".get_children().empty()



func _on_Refresh_pressed():
	update_set_lines()

func _on_Save_pressed():
	update_set_lines()
	save_set()

func _on_AddLine_pressed():
	local_set.append_array( glbl.get_default_lines() )
	$Editor/ScrollContainer/ArrayData.add_child( load("res://Scene/ArrayLinesSet.tscn").instance() )

func _on_Close_pressed():
	pass # Replace with function body.



func _on_self_visibility_changed():
	if self.visible:
		update_set_lines()
