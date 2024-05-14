import io
import net

fn main() {
	mut server := net.listen_tcp(.ip6, ':8765')!
	laddr := server.addr()!
	eprintln('Listen on ${laddr} ...')
	for {
		mut socket := server.accept()!
		spawn handle_client(mut socket)
	}
}

fn handle_client(mut socket net.TcpConn) {
	defer {
		socket.close() or { panic(err) }
	}
	client_addr := socket.peer_addr() or { return }
	eprintln('> new client: ${client_addr}')
	mut reader := io.new_buffered_reader(reader: socket)
	defer {
		unsafe {
			reader.free()
		}
	}

	socket.write_string(' === Socket opened === \n') or { return }
	for {
		received_line := reader.read_line() or { return }
		if received_line == '' {
			return
		}
		println('client ${client_addr}: ${received_line}')
		socket.write_string('server: ${received_line}\n') or { return }
	}
}

// nc 127.0.0.1 8765
