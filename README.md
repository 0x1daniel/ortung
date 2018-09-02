# ortung :mag:

track you data sources

## About

`ortung` is a small tool to track the servers that send you data _(incoming traffic)_. Each request will be counted and
located through the `MaxMind GeoIP Database`. The collected statistics will be then visualized on a map and can be
requested through the API.

## Routes

| route | description |
| - | - |
| `/` | serve the html that will visualize the data |
| `/ws` | the websocket access route for interval based data |
| `data` | the latest statistics in json |

## Procedure

Each received packet will be parsed. If an IP address can be extracted from that protocol, `ortung` will update the
statistics, and locate the source IP to update the countries statistics. The data will be then updated and broadcasted
every 2 seconds.

## Installation

```bash
# Install all dependencies
$ bundle
# Download MaxMind GeoIP Country Lite Database
$ sh scripts/load-geoip.sh
# Start the server
# (sudo required for taping the interfaces)
$ sudo bin/ortung
```

## Todo

- [] build the map
- [] application arguments _(port, interval, interface)_

## License

###### MaxMind GeoIP Database is licensed by the [`Creative Commons 3.0 License`](https://creativecommons.org/licenses/by/3.0/us/).

_Just do what you'd like to_

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/oltdaniel/ortung/blob/master/LICENSE)

#### Credit

[Daniel Oltmanns](https://github.com/oltdaniel) - creator
