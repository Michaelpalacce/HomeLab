# Keepalived ( deprecated for kube-vip )

Keepalived allows me to use one specific ip when communicating with my server, so I can have high availability

firstServer
~~~ini
vrrp_instance VI_1 {
        state MASTER
        interface enp1s0
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

secondServer
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface ens18
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

thirdServer
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface ens18
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

fourthServer
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface ens18
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

fifthServer
~~~ini
vrrp_instance VI_1 {
        state BACKUP
        interface ens18
        virtual_router_id 51
        priority 251
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
