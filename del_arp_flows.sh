#!/bin/bash

for sw in 1 2 3 4 101 102 103 104
do
  echo openflow:${sw}
  curl -X DELETE --user admin:admin http://127.0.0.1:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:${sw}/table/0/
done
