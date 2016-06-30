#!/bin/bash

#for sw in s1 s2 s3
for sw in 1 2 3 4 101 102 103 104
do
  echo ${sw}
  sudo ovs-ofctl del-flows s${sw} -O OpenFlow13
  echo ''
done

