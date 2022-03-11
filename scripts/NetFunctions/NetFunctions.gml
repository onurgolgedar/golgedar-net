function net_client_send(code, data = 0, bufferType = BUFFER_TYPE_BOOL, isUDP = false, bufferInfo = BUFFER_INFO_DEFAULT, forCOOP = false) {
	if (!is_net_local(global.serverIP, global.coopID) or forCOOP or debug_mode) {
		isUDP = global.all_tcp_mode ? false : isUDP
		
		if (global.coopID != "" and bufferInfo == BUFFER_INFO_DEFAULT)
			bufferInfo = global.socket_CLIENT

		var buffer = buffer_create(36, buffer_grow, 1)
		buffer_seek(buffer, buffer_seek_start, 0)
		buffer_write(buffer, buffer_u8, bufferType)
		buffer_write(buffer, buffer_u16, code)
		buffer_write(buffer, net_buffer_get_type(bufferType), data)
		buffer_write(buffer, buffer_u16, bufferInfo)

		var socket = net_get_client_socket(forCOOP)
		if (isUDP)
			network_send_udp(socket, global.serverIP, global.mainUDP_port, buffer, buffer_tell(buffer))
		else
			network_send_packet(socket, buffer, buffer_tell(buffer))
			
		buffer_delete(buffer)
	}
	else
		_net_receive_packet(code, data, global.socketID_player)
}

function net_server_send(socketID, code, data = 0, bufferType = BUFFER_TYPE_BOOL, isUDP = false, location = 0, bufferInfo = 65535) {
	var buffer = undefined	
	
	if (socketID != global.socketID_player) {
		isUDP = global.all_tcp_mode ? false : isUDP
		
		if (socketID == SOCKET_ID_ALL) {
			var ds_size = db_get_table_size(global.DB_TABLE_clients)
			for (var i = 0; i < ds_size; i++) {
				var _playerRow = db_get_row_by_index(global.DB_TABLE_clients, i)
	
				var _socketID = _playerRow[? CLIENTS_SOCKETID]
				var buffer = net_make_buffer(code, data, bufferType, bufferInfo)
			
				if (_socketID != global.socketID_player) {
					if (isUDP)
						network_send_udp(_socketID, _playerRow[? CLIENTS_IP], PORT_UDP, buffer, buffer_tell(buffer))
					else
						network_send_packet(_socketID, buffer, buffer_tell(buffer))
				}
				else
					_net_receive_packet(code, data, _socketID)
			}
		}
		else {
			var buffer = net_make_buffer(code, data, bufferType, bufferInfo)
			
			if (socketID != global.socketID_player) {
				if (isUDP) {
					var _playerRow = db_get_row(global.DB_TABLE_clients, socketID)
			
					if (_playerRow != undefined)
						network_send_udp(socketID, _playerRow[? CLIENTS_IP], PORT_UDP, buffer, buffer_tell(buffer))
				}
				else
					network_send_packet(socketID, buffer, buffer_tell(buffer))
			}
			else
				_net_receive_packet(code, data, socketID)
		}

		if (buffer != undefined)
			buffer_delete(buffer)
	}
	else
		_net_receive_packet(code, data, socketID)
}

function net_buffer_read(buffer) {
	buffer_seek(buffer, buffer_seek_start, 0)
	var bufferType = net_buffer_get_type(buffer_read(buffer, buffer_u8))
	var code = buffer_read(buffer, buffer_u16)

	if (bufferType != undefined and code != undefined) {
		var returned
		returned[0] = code
		returned[1] = buffer_read(buffer, bufferType)
		returned[2] = buffer_read(buffer, buffer_u16)
		returned[3] = bufferType
		
		return returned
	}
	else
		return undefined
}

function net_make_buffer(code, data, bufferType, bufferInfo) {
	var buffer = buffer_create(36, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, bufferType)
	buffer_write(buffer, buffer_u16, code)
	buffer_write(buffer, net_buffer_get_type(bufferType), data)
	buffer_write(buffer, buffer_u16, bufferInfo)
	return buffer
}

function net_buffer_get_type(bufferType) {
	switch (bufferType) {
		case BUFFER_TYPE_BOOL:
			return buffer_bool
		case BUFFER_TYPE_BYTE:
			return buffer_u8
		case BUFFER_TYPE_INT16:
			return buffer_s16
		case BUFFER_TYPE_INT32:
			return buffer_s32
		case BUFFER_TYPE_FLOAT16:
			return buffer_f16
		case BUFFER_TYPE_FLOAT32:
			return buffer_f32
		case BUFFER_TYPE_FLOAT64:
			return buffer_f64
		case BUFFER_TYPE_STRING:
			return buffer_string
	}
}

function net_buffer_get_type_reverse(bufferType) {
	switch (bufferType) {
		case buffer_bool:
			return BUFFER_TYPE_BOOL
		case buffer_u8:
			return BUFFER_TYPE_BYTE
		case buffer_s16:
			return BUFFER_TYPE_INT16
		case buffer_s32:
			return BUFFER_TYPE_INT32
		case buffer_f16:
			return BUFFER_TYPE_FLOAT16
		case buffer_f32:
			return BUFFER_TYPE_FLOAT32
		case buffer_f64:
			return BUFFER_TYPE_FLOAT64
		case buffer_string:
			return BUFFER_TYPE_STRING
	}
}

function net_get_client_socket(forCOOP) {
	return global.socket
}

function is_net_local(serverIP, coopID) {
	return serverIP == "127.0.0.1" and (coopID == "" or coopID == undefined)
}