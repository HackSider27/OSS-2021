#!/bin/bash

find ~ -type f -name "*.txt" > /tmp/qwe
cat /tmp/qwe 
cat /tmp/qwe | xargs du -acb 2>/dev/null | tail -1 | cut -f1
cat /tmp/qwe | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}'
rm /tmp/qwe
