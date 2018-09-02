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

require 'oj'
require 'geoip'
require 'socket'

module Ortung
  class Statistics
    def initialize
      @counter = 0
      @sources = Hash.new(0)
      @countries = Hash.new(0)
      @local = Socket.ip_address_list[1].ip_address[/.*(?=\.\d+\z)/]
      @geo = GeoIP.new(File.dirname(__FILE__) + '/../../data/GeoIP.dat')
    end

    def analyze(packet)
      pkt = PacketFu::Packet.parse packet
      if pkt.is_ip?
        @counter += 1
        sip = pkt.ip_saddr
        country = @geo.country(sip)
        return if sip.start_with?(@local)
        @sources[sip] += 1
        @countries[country.country_name] += 1 if !country.nil? && !country.country_name.nil?
      end
    end

    def to_json
      Oj.dump({
        'total': @counter,
        'sources': @sources,
        'countries': @countries
      })
    end
  end
end
