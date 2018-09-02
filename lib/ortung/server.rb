# MIT License
#
# Copyright (c) 2018 Daniel Oltmanns
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'sinatra'
require 'sinatra-websocket'

module Ortung
  class Server < Sinatra::Base
    configure do
      set :bind, '127.0.0.1'
      set :sockets, []
      set :root, "#{settings.root}/../.."
      set :latest, "no data"
    end

    get '/' do
      erb :index, :layout => :'layouts/main'
    end

    get '/ws' do
      error 403 if !request.websocket?

      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end
        ws.onmessage do |msg|
          ws.send("no messages accepted")
        end
        ws.onclose do
          settings.sockets.delete(ws)
        end
      end
    end

    get '/data' do
      content_type :json
      settings.latest
    end

    def self.broadcast(msg)
      set :latest, msg
      EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
    end
  end
end
