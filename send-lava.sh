#!/bin/sh

cd "$(dirname "$0")"

scp -r ./lava lava:~
