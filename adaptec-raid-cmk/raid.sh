#!/bin/bash

if ! which arcconf > /dev/null 2>&1; then
    echo "arcconf cli executable not found!"
    exit 1
fi

# Physical Disk monitoring
PHYSICAL_DISK_COUNT=$(arcconf LIST 1 | grep -E 'Physical [0-9]' | wc -l)
if [ "$PHYSICAL_DISK_COUNT" -lt 1 ]; then
    echo "No Physical Disks found."
    exit 1
fi

for i in $(seq 1 "$PHYSICAL_DISK_COUNT"); do
    PHYSICAL_DISK_STATE=$(arcconf LIST 1| grep -E 'Physical [0-9]' | cut -d ':' -f 2| sed -n "${i}p")
    
    if ! echo "$PHYSICAL_DISK_STATE" | grep -q "Online"; then
        echo "2 "Physical Disk ${i}" -${PHYSICAL_DISK_STATE}"
    else
        echo "0 \"Physical Disk ${i}\" -${PHYSICAL_DISK_STATE}"
    fi
done

# Basic SMART Monitoring
SMART_WARNINGS_COUNT=$(arcconf GETCONFIG 1 | grep "S.M.A.R.T. warnings" | cut -d ':' -f2 | sed 's/ //g' | wc -l)

for i in $(seq 1 "$SMART_WARNINGS_COUNT"); do
    SMART_WARNING=$(arcconf GETCONFIG 1| grep "S.M.A.R.T. warnings" | cut -d ':' -f2 | sed 's/ //g' | sed -n "${i}p")

    if ! echo "$SMART_WARNING" | grep -q "0"; then
        echo "2 \"S.M.A.R.T. Disk ${i}\" - Warnings: ${SMART_WARNING}"
    else
        echo "0 \"S.M.A.R.T. Disk ${i}\" - Warnings: ${SMART_WARNING}"
    fi
done

# Logical Disk Monitoring
LOGICAL_DISK_COUNT=$(arcconf LIST 1 | grep -E 'Logical [0-9]' | wc -l)
if [ "$LOGICAL_DISK_COUNT" -lt 1 ]; then
    echo "No Logical Disks found."
    exit 1
fi

for i in $(seq 1 "$LOGICAL_DISK_COUNT"); do
    LOGICAL_DISK_STATE=$(arcconf LIST 1| grep -E 'Logical [0-9]' | cut -d ':' -f 2| sed -n "${i}p")

    if ! echo "$LOGICAL_DISK_STATE" | grep -q "Optimal"; then
        echo "2 "Logical Disk ${i}" -${LOGICAL_DISK_STATE}"
    else
        echo "0 \"Logical Disk ${i}\" -${LOGICAL_DISK_STATE}"
    fi
done

# RAID Controller Monitoring
CONTROLLER_COUNT=$(arcconf LIST 1 | grep -E 'Controller [0-9]' | wc -l)
if [ "$CONTROLLER_COUNT" -lt 1 ]; then
    echo "No Logical Disks found."
    exit 1
fi

for i in $(seq 1 "$CONTROLLER_COUNT"); do
    CONTROLLER_STATE=$(arcconf LIST 1| grep -E 'Controller [0-9]' | cut -d ':' -f 3| sed -n "${i}p")

    if ! echo "$CONTROLLER_STATE" | grep -q "Optimal"; then
        echo "2 "Controller ${i}" -${CONTROLLER_STATE}"
    else
        echo "0 \"Controller ${i}\" -${CONTROLLER_STATE}"
    fi
done

