#!/bin/bash
wget geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz -O data/GeoIP.dat.gz
gzip -d data/GeoIP.dat.gz
