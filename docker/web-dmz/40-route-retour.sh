#!/bin/sh
ip route replace 172.20.2.0/24 via 172.20.1.1
ip route replace 172.20.3.0/24 via 172.20.1.1
