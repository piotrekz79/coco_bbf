*** Settings ***
Documentation     Test of invitation system    #TODOs    #-instead of bare curl consider using keywords such as Get Data From URI etc.    #-parametrize agent's address and port, possibly headers etc.
Suite Setup       Start Suite
Suite Teardown    Stop Suite
Library           SSHLibrary
Library           RequestsLibrary
Resource          /home/coco/test/csit/libraries/Utils.robot
Resource          /home/coco/test/csit/libraries/KarafKeywords.robot
Library           HttpLibrary.HTTP

*** Variables ***
${COCO_IP}        localhost
${COCO_PORT}      9090

*** Test Cases ***
login test
    Log    Start

intent bundle test
    Verify Feature Is Installed    odl-vpnservice-intent

remove ARP flows
    [Documentation]    Remove arp flows and check if indeed they are gone
    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    /home/coco/demo_bbf/del_arp_flows.sh    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    #${output}    Read Until    ${TOOLS_SYSTEM_PROMPT}
    ${output}    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    /home/coco/demo_bbf/dumpflows_all.sh    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    Log    ${output}
    Should Not Contain    ${output}    arp

Check for existing VPNs
    [Documentation]    Check if there are any VPNs
    ${output}    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpns' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    Should Be Equal    ${output}    []

Add VPN1
    [Documentation]    Adds (empty) VPN
    #${tmpcmd}=    "curl 'http://localhost:9090/CoCo-agent/rest/vpn/add' -H 'Origin: http://localhost:9090' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"id":0,"name":"vpn1","pathProtection":false,"failoverType":"slow-reroute","sites":[]}' --compressed"
    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpn/add' -H 'Origin: http://localhost:9090' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"id":0,"name":"vpn1","pathProtection":false,"failoverType":"slow-reroute","sites":[]}' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}

Get VPN1 ID
    [Documentation]    Stores VPN ID given by CoCo agent; will be needed to add hosts and delete VPN
    ${output}    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpns' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    Log    ${output}
    ${output2}=    Get Substring    ${output}    1    -1    #output has a form of [{"id":1...}]; we need to get rid of []
    Log    ${output2}
    ${vpnid1}    Get Json Value    ${output2}    /id
    Log    ${vpnid1}
    Set Suite Variable    ${vpnid1}

Add hosts to VPN1
    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpn/update/${vpnid1}' -H 'Origin: http://localhost:9090' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"id":${vpnid1},"sites":[{"id":1,"name":"h1"}]}' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpn/update/${vpnid1}' -H 'Origin: http://localhost:9090' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"id":${vpnid1},"sites":[{"id":1,"name":"h1"},{"id":3,"name":"h3"}]}' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}

Ping hosts in VPN1
    [Documentation]    Ping should be successful
    Switch Connection    ${mininet_conn_id}
    SSHLibrary.Write    h1 ping -c 5 h3
    ${output}    Read Until    mininet>
    Log    ${output}
    Should Contain    ${output}    5 received

Ping hosts outside VPN1
    [Documentation]    Ping should NOT successful - traffic should not leak
    Switch Connection    ${mininet_conn_id}
    SSHLibrary.Write    h1 ping -c 5 h2
    ${output}    Read Until    mininet>
    Log    ${output}
    Should Contain    ${output}    100% packet loss

Delete VPN1
    [Documentation]    Deletes VPN
    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpn/del/${vpnid1}' -H 'Origin: http://localhost:9090' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"id":${vpnid1},"name":"die","pathProtection":"die","failoverType":"fast-reroute"}' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}

Check for deleted VPNs
    [Documentation]    see if VPN list is empty
    ${output}    Run Command On Mininet    ${TOOLS_SYSTEM_IP}    curl 'http://localhost:9090/CoCo-agent/rest/vpns' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://localhost:9090/CoCo-agent/static/index.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed    ${TOOLS_SYSTEM_USER}    ${TOOLS_SYSTEM_PASSWORD}    prompt=${TOOLS_SYSTEM_PROMPT}
    Should Be Equal    ${output}    []

Ping hosts in deleted VPN1
    [Documentation]    Ping should NOT successful - VPN does not exist any more
    Switch Connection    ${mininet_conn_id}
    SSHLibrary.Write    h1 ping -c 5 h3
    ${output}    Read Until    mininet>
    Log    ${output}
    Should Contain    ${output}    100% packet loss

test json
    [Tags]    test
    ${tmpstr}=    Set Variable    [{"id":3,"name":"vpn1","pathProtection":"false","failoverType":"slow-reroute","sites":[],"pathProtectionBoolean":false}]
    Log    ${tmpstr}
    ${tmpstr2}=    Get Substring    ${tmpstr}    1    -1
    Log    ${tmpstr2}
    ${vpnid1}    Get Json Value    ${tmpstr2}    /id
    Log    ${vpnid1}
    #    Set Suite Variable    ${vpnid1}

test json2
    [Tags]    test
    Log    ${vpnid1}
