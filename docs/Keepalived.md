# Keepalived

Keepalived allows me to use one specific ip when communicating with my server, so I can have high availability

PI48-ubuntu
~~~ini
vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 255
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass 12345678
        }
        virtual_ipaddress {
              192.168.1.2/24
        }
}
~~~

PI48-ubuntu-1
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 51
        priority 254
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass 12345678
        }
        virtual_ipaddress {
              192.168.1.2/24
        }
}
~~~

PI48-ubuntu-2
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 51
        priority 253
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass 12345678
        }
        virtual_ipaddress {
              192.168.1.2/24
        }
}
~~~

PI48-ubuntu-3
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 51
        priority 252
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass 12345678
        }
        virtual_ipaddress {
              192.168.1.2/24
        }
}
~~~
