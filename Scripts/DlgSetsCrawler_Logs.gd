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

func _on_CrawlerSetWarning_popup_hide():
	self.clear_logs()
	$"../../../../..".visible			= false
	$"../../../../../../DimBG".visible	= false

func _on_CrawlerSetWarning_visibility_changed():
	$"../../../../..".visible			= self.visible
	$"../../../../../../DimBG".visible	= self.visible
