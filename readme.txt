 Demo
1) start ODL
/home/coco/vpnservice-karaf-intent/distribution-karaf-0.4.2-Berylium-SR2-clean/bin/karaf

2) start mysql
...

Note: if using topo_bbf1_db.py (recommended, see below) then the database is automatically
populated based on mininet topology. As a backup option, there is 
demo_bbf_clean.sql file which contains all needed but empty tables.
Use it in case of troubles, when 'factory reset' is needed etc. or when
you comment out line 402 in topo_bbf1db.py
402 |	databaseDump(net)
 

#DON'T RUN UNLESS YOU KNOW WHAT YOU ARE DOING

3) start mininet
cd /home/coco/demo_bbf
sudo python topo_bbf1_db.py

4) kill arp flows (static arps installed on the hosts)
/home/coco/demo_bbf/del_arp_flows.sh

5) start CoCo portal
        5a) run Eclipse
        5b) within Eclipse go to "Servers" tab (bottom panel)
        5c) Right click "Tomcat v7.0 Server at localhost" and click "Start"

6) connect hosts (e.g., h1 and h2) in CoCo portal and check connectivity from mininet
mininet> xterm h1
ping 10.0.2.1
