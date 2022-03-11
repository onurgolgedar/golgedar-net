#region FUNCTION DECLARATIONS
function client_connect(ip, port) {
	network_set_config(network_config_connect_timeout, 1000)
	
	if (global.socket != undefined)
		network_destroy(global.socket)	
	
	global.socket = network_create_socket(network_socket_tcp)
	network_connect(global.socket, ip, port)
}
#endregion

global.socketID_player = undefined
ini_open("config.ini")
	global.all_tcp_mode = ini_read_string("NETWORK", "ALL_TCP_MODE", 1)
ini_close()

_db_init()
_db_event_table_creation()
_db_event_table_column_names()

event_user(0)