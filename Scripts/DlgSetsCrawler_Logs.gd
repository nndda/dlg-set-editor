extends Control

func clear_logs():
	if self.get_child_count() > 0:
		for logs in self.get_children():
			logs.queue_free()

func add_log( logged_result : Dictionary ):
	for results in logged_result.keys():
		var log_item = load("res://Scripts/DlgSetsCrawler_LogItem.tscn").instance()
		log_item.get_node("Value/file_name").text	= str( glbl.get_res_filename( results ) )
		log_item.get_node("Value/lines").text		= str( logged_result[ results ] )
		self.add_child( log_item )
#	var LogItm = VBoxContainer.new()
#	var HSep = HSeparator.new()
#	LogItm.add_child( HSep )


#	var Labels				= HBoxContainer.new()
#
#	var Labels_ChrName		= Label.new()
#	Labels_ChrName.text = "Property"
#	Labels_ChrName.set_h_size_flags( Control.SIZE_EXPAND_FILL )
#
#	var Labels_ChrIdx		= Label.new()
#	Labels_ChrIdx.text = "Step"
#	Labels_ChrIdx.set_h_size_flags( Control.SIZE_EXPAND_FILL )
#
#
#
#	var Log_Value			= HBoxContainer.new()
#
#	var Log_Value_ChrName	= Label.new()
#	Log_Value_ChrName.text = "Step"
#	Log_Value_ChrName.set_h_size_flags( Control.SIZE_EXPAND_FILL )
#
#	var Log_Value_ChrIdx	= Label.new()
#	Log_Value_ChrIdx.text = "Step"
#	Log_Value_ChrIdx.set_h_size_flags( Control.SIZE_EXPAND_FILL )
#
#
#
#	var FileName			= Label.new()
#
#	FileName.text = str( logged_result[ 0 ] )
#	FileName.set_h_size_flags( Control.SIZE_EXPAND_FILL )
#
#	var FilePath			= Label.new()
#
#	FilePath.text = "Step"
#	FilePath.set_h_size_flags( Control.SIZE_EXPAND_FILL )


func _on_CrawlerSetWarning_popup_hide():
	self.clear_logs()
	$"../../../../..".visible			= false
	$"../../../../../../DimBG".visible	= false

func _on_CrawlerSetWarning_visibility_changed():
	$"../../../../..".visible			= self.visible
	$"../../../../../../DimBG".visible	= self.visible
