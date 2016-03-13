# require 'rack'
require 'socket'
require 'pry'

#Below is the ruby code for setting up a simple rack server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#================= Steps that Still Need to be Completed =============================
#1. [ done ] define server as server = TCPServer ( :host, :port)
#2. [ done ] TCPServer.accept = socket
#3. [  ]socket.parse  (where parse is our method for parsing the steam, has to be unit tested)
#4. [  ]****** parse will return a hash *******
#5. [  ]****** hash is handed to @app *******
#6. [  ]***** app returns an array of [status, headers, body] *******
#7. [  ]***** socket.print/puts array *********
#8. [  ]***** close the socket **********
#9. [  ]***** next iteration: for multiple request handling, set up a loop *****
#10.[  ]***** ATSOME POINT figure out where/when in code to close server ***********
#
#
#
#***for unit test might need rack.input as a commmand of some sort ****
#*** unit test also needs to use stringerIO to feed string *********c

class Notes
  class Web
    def initialize(address)
      @port = address[:port]
      @host = address[:host]
      @server = TCPServer.new @host, @port
    end

    def stop
      @server.close
    end

    def start
      loop do
        socket = @server.accept

        # binding.pry
        method, path, http_version = socket.gets.chomp.split(" ")

        puts "#{method}, #{path}, #{http_version}"

        if path == "/form"
          body = File.read("form.html")
          status = "200"
          socket.print "#{http_version} #{status} OK\r\n"
          socket.print "Content-Type: text/html \r\n"
          socket.print "Content-Length: #{body.length}\r\n"
          socket.print "\r\n"
          socket.print body
        end

        if path.start_with? "/search"
          path, parameters = path.split("?")
          parameters.split("&").each do |params|
            key, value = params.split("=")
            puts "#{key} has the value #{value}"
          end
        end

        socket.close
      end
    end
  end
end

server = Notes::Web.new({port: "3000", host: "localhost"})
server.start
