#!/bin/bash
#
set -e  # abort on errors

D=$(dirname "$0")
cd "$D"
export PERL_UNICODE=""  # everything unicode by default
exec ./mqtt_logger.pl
