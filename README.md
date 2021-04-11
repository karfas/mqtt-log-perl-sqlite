# mqtt-log-perl-sqlite

A simple log-everything application, using perl and a SQLite database.

This assumes that the MQTT values are UTF-8 strings.

## Requirements:

- perl
- perl modules:
  - DBD::Sqlite3
  - Net::MQTT::Simple 
- a MQTT broker (e.g. mosquitto)

