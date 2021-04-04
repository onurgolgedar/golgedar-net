_db_init()
server_init()

global.DB_TABLE_clients = db_create_table("Clients", 7541)
db_set_column_name(global.DB_TABLE_clients, CLIENTS_SOCKETID, "SocketID")
db_set_column_name(global.DB_TABLE_clients, CLIENTS_IP, "IP")

_db_event_table_creation()
_db_event_table_column_names()