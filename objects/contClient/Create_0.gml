#region FUNCTION DECLARATIONS
function client_connect(ip, port) {
	global.socket = network_create_socket(network_socket_tcp)

	return network_connect_async(global.socket, ip, port) >= 0
}
#endregion

global.socketID_player = undefined

_db_init()
_db_event_table_creation()
_db_event_table_column_names()

alarm[0] = room_speed/2