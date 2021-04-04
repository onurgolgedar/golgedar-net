function net_buffer_get_type() {
	switch (argument[0]) {
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

/// @param buffer
function net_buffer_read() {
	var buffer = argument[0]

	buffer_seek(buffer, buffer_seek_start, 0)
	var bufferType = net_buffer_get_type(buffer_read(buffer, buffer_u8))
	var code = buffer_read(buffer, buffer_u16)

	var returned
	returned[0] = code
	returned[1] = buffer_read(buffer, bufferType)

	return returned
}

/// @param code
/// @param data* (req: bufferType)
/// @param bufferType*
/// @param isUDP*
function net_client_send() {
	var code = argument[0]
	var data = argument_count == 1 ? 0 : argument[1]
	var bufferType = argument_count == 1 ? BUFFER_TYPE_BOOL : argument[2]
	var isUDP = argument_count < 5 ? false : argument[4]

	var buffer = buffer_create(32, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, bufferType)
	buffer_write(buffer, buffer_u16, code)
	buffer_write(buffer, net_buffer_get_type(bufferType), data)

	if (isUDP)
		network_send_udp(global.socket, global.serverIP, PORT_UDP, buffer, buffer_tell(buffer))
	else
		network_send_packet(global.socket, buffer, buffer_tell(buffer))
			
	buffer_delete(buffer)
}

/// @param socketID
/// @param code
/// @param data* (req: bufferType)
/// @param bufferType*
/// @param isUDP*
function net_server_send() {
	var socketID = argument[0]
	var code = argument[1]
	var data = argument_count < 3 ? 0 : argument[2]
	var bufferType = argument_count < 4 ? BUFFER_TYPE_BOOL : argument[3]
	var isUDP = argument_count < 5 ? false : argument[4]

	var buffer = buffer_create(32, buffer_grow, 1)
	buffer_seek(buffer, buffer_seek_start, 0)
	buffer_write(buffer, buffer_u8, bufferType)
	buffer_write(buffer, buffer_u16, code)
	buffer_write(buffer, net_buffer_get_type(bufferType), data)

	if (socketID == SOCKET_ID_ALL) {
		var ds_size = db_get_table_size(global.DB_TABLE_clients)
		for (var i = 0; i < ds_size; i++) {
			var _playerRow = db_get_row_by_index(global.DB_TABLE_clients, i)
			var _socketID = _playerRow[? CLIENTS_SOCKETID]
			
			if (isUDP)
				network_send_udp(_socketID, _playerRow[? CLIENTS_IP], PORT_UDP, buffer, buffer_tell(buffer))
			else
				network_send_packet(_socketID, buffer, buffer_tell(buffer))
		}
	}
	else {
		if (isUDP) {
			var _playerRow = db_get_row(global.DB_TABLE_clients, socketID)
			
			network_send_udp(socketID, _playerRow[? CLIENTS_IP], PORT_UDP, buffer, buffer_tell(buffer))
		}
		else
			network_send_packet(socketID, buffer, buffer_tell(buffer))
	}


	buffer_delete(buffer)
}