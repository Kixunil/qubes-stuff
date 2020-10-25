#!/bin/bash

# Occasionally it happens that the network gets stuck.
# (Although, it didn't happen for quite a long time.)
# The only way I know of to solve that is to reboot `sys-net`.
# However, clicking "Shutdown" doesn't work because `sys-firewall` depends on it.
# The solution is to detach `sys-firewall` before shutting it down and reattach if afterwards.

# This must be run in dom0

qvm-prefs --set sys-firewall netvm None

qvm-shutdown -q --wait --timeout 30 sys-net
qvm-start -q sys-net

qvm-prefs --set sys-firewall netvm sys-net
