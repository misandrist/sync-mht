#!/bin/bash
# Stars the ssh service, creates a key pair and authorizes its public part such that
# password less ssh-login self ssh login is possible.
(
    service ssh start
    ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
    ssh -o StrictHostKeyChecking=no 127.0.0.1 /bin/true
    cd /sync-mht
    tc qdisc add dev lo root tbf rate 1mbit latency 10ms burst 10k
    cabal bench benchmarks --benchmark-option="/.cabal/bin/sync-mht" --benchmark-option="$1"
) > /dev/nul
cat benchmarks.json
