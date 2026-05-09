#!/bin/bash
sudo /usr/sbin/sshd
code serve-web --without-connection-token --accept-server-license-terms --host 0.0.0.0 --port 8080
