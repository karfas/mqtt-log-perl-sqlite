#!/usr/bin/perl
#
# MQTT data logger
#
# 2021-04-11 TW created
#
use v5.14; # optimal for unicode string feature
use utf8;
use strict;
use warnings;

use Encode qw(decode encode);
use Net::MQTT::Simple;
use DBI;

my $mqtt_server = '127.0.0.1';
my $db_file = "mqtt.sq3";
my $db_options = {AutoCommit => 0, RaiseError => 1, sqlite_unicode => 1 };

my $mqtt = Net::MQTT::Simple->new($mqtt_server);
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file", "", "", $db_options);

state $sth = $dbh->prepare(<<_end);
    SELECT mql_topic, mql_value
      FROM mqtt_log A
     WHERE mql_time_utc = (
        SELECT max(mql_time_utc)
          FROM mqtt_log B
         WHERE B.mql_topic = A.mql_topic)
       AND mql_topic = ?
_end

state $ins = $dbh->prepare(<<_end);
    INSERT INTO mqtt_log(mql_topic, mql_value)
    VALUES(?, ?)
_end

my $cb = sub {
    my ($topic, $msg) = @_;
    # print "[$topic] $message\n";

    my $message = decode('UTF-8', $msg, Encode::FB_CROAK);

    $sth->execute($topic);
    if (my @row = $sth->fetchrow())
        {
        my $val = $row[1];
        return 0 if ($val eq $message);
        }
    print "insert: [$topic] $message\n";
    $ins->execute($topic, $message);
    $dbh->commit();
    return 1;
    };


$mqtt->run(
    "#" => $cb
    );
