port = ENV['PORT'] || 8080
port = port.to_i

tcp = UV::TCP.new
tcp.bind UV::ip4_addr '127.0.0.1', port

parser = HTTP::Parser.new

connection_list = []

print "starting server\n"

tcp.listen(5) do |x|
  return if x != 0

  connection = tcp.accept
  connection_list << connection

  connection.read_start do |body|
    req = parser.parse_request body
    print "#{req.method}: #{req.path}\n"
    connection.write("HTTP/1.1 200 OK\r\nHost: localhost\r\n\r\nHello World!") do |v|
      print "response status: #{v == 0 ? :success : :failure}\n"
      connection.close
    end
  end
end

UV.run
