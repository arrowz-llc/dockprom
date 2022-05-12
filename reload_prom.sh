#!/bin/bash

promtool='docker-compose exec prometheus promtool'

error_found=0

${promtool} check config /etc/prometheus/prometheus.yml || error_found=1

# See mapping in docker-compose
# ./config/:/config/ allow us a local lookup and remote check
# of rules files
#for rules_file in ./config/alerts/*yml
#do
#    ${promtool} check rules "/${rules_file}" || error_found=1
#done

if [[ ${error_found} -gt 0 ]]; then
    echo "Not reloading config, errors found."
else
    docker-compose kill -s SIGHUP prometheus
fi

