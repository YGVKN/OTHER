#!/usr/bin/ruby

require 'socket'

port = (ARGV[0] || 8765).to_i

server = TCPServer.new port

p server
puts "=== Socket opened #{port} ==="

loop do
  client = server.accept
  client.puts "#{client.gets}"
  #client.puts "Request: #{client.gets}"
  #client.print "HTTP/1.1 200/OK\r\nContent-type: text/html\r\n\r\n"
  #client.print "#{Time.now}\r\n"
  client.close
end
