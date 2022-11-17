extends VBoxContainer

func _msg(message : String):
	print(message)
	var nlog = Label.new()
	nlog.text = message
