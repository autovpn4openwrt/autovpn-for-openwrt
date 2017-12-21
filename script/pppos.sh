#!/bin/bash

set $SSH_ORIGINAL_COMMAND >/dev/null
exec sudo pppd noauth nodetach notty
