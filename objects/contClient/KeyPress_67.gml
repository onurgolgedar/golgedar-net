ini_open("config.ini")
	global.serverIP = ini_read_string("SERVER", "IP", "127.0.0.1")
ini_close()

client_connect(global.serverIP, PORT_TCP)