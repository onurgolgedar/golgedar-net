_db_init()
_server_init()

global.DB_TABLE_clients = db_create_table("Clients", 7541)
db_set_column_name(global.DB_TABLE_clients, CLIENTS_SOCKETID, "SocketID")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_IP, "IP")

global.socketID_player = undefined
ini_open("config.ini")
	global.all_tcp_mode = ini_read_string("NETWORK", "ALL_TCP_MODE", 1)
ini_close()

_db_event_table_creation()
_db_event_table_column_names()