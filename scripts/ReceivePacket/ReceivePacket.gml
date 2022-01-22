function _net_receive_packet(code, pureData, socketID_sender) {
	var data
	#region PARSE PARAMETERS
	var parameterCount = 0
	if (is_string(pureData) and string_count("|", pureData) > 0) {
		parameterCount = string_count("|", pureData)
		var cut = 0
		var parameterIndex = 0
		for (var i = 2; i <= string_length(pureData)+1; i++) {
		
			if (i == string_length(pureData)+1 or string_char_at(pureData, i) == "|") {
				var parameter = string_copy(pureData, cut+1, i-cut-1)
				data[parameterIndex] = parameter

				cut = i
				parameterIndex++
			}
		}
	}
	else
		data[0] = argument[1]
	#endregion

	try {
		/*switch(code) {

		}*/
	}
	catch (error) {
		show_debug_message(error)
	}
}