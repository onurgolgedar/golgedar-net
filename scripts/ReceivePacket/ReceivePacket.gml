function _net_receive_packet(code, pureData, socketID_sender, bufferInfo, bufferType, asyncMap) {
	var data
	#region PARSE PARAMETERS
	var parameterCount = 0
	if (is_string(pureData)) {
		if (string_char_at(pureData, 0) == "{" or string_char_at(pureData, 0) == "[")
			data = json_parse(pureData)
		else {
			parameterCount = 1
			data = pureData
		}
	}
	else {
		parameterCount = 1
		data = pureData
	}
	#endregion

	try {
		/*switch(code) {

		}*/
	}
	catch (error) {
		show_debug_message(error)
	}
}