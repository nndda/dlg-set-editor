extends Control

func add_log( logged_result ):
	var LogItm = VBoxContainer.new()
	var HSep = HSeparator.new()
	LogItm.add_child( HSep )


	var Labels				= HBoxContainer.new()

	var Labels_ChrName		= Label.new()
	Labels_ChrName.text = "Property"
	Labels_ChrName.set_h_size_flags( Control.SIZE_EXPAND_FILL )

	var Labels_ChrIdx		= Label.new()
	Labels_ChrIdx.text = "Step"
	Labels_ChrIdx.set_h_size_flags( Control.SIZE_EXPAND_FILL )



	var Log_Value			= HBoxContainer.new()

	var Log_Value_ChrName	= Label.new()
	Log_Value_ChrName.text = "Step"
	Log_Value_ChrName.set_h_size_flags( Control.SIZE_EXPAND_FILL )

	var Log_Value_ChrIdx	= Label.new()
	Log_Value_ChrIdx.text = "Step"
	Log_Value_ChrIdx.set_h_size_flags( Control.SIZE_EXPAND_FILL )



	var FileName			= Label.new()

	FileName.text = str( logged_result[ 0 ] )
	FileName.set_h_size_flags( Control.SIZE_EXPAND_FILL )

	var FilePath			= Label.new()

	FilePath.text = "Step"
	FilePath.set_h_size_flags( Control.SIZE_EXPAND_FILL )
