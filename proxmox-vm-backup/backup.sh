#!/bin/bash
vm_running() {
    if [ "$(qm status $VMID)" == "status: running" ]; then
        return 1
    fi
    return 0
}

backup_vm() {
    mkdir "${BACKUP_DIR}/${VMID}"

    if vzdump $VMID --mode stop --compress zstd --dumpdir "${BACKUP_DIR}/${VMID}/"; then
        return 0
    else
        return 1
    fi
}

# help page
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Backup Proxmox VM."
  echo
  echo "Options:"
  echo "  -h, --help                             Show this help message and exit"
  echo "  -vm, --vmid XXX                        Specify the ID of the VM."
  echo "  -dir, --backup_dir /path/to            Specify the local path to which the backup should be saved."
  echo
}


main() {
    # Parse script arguments
    # shellcheck disable=SC2034 
    if [ "$#" -ne 0 ]; then
        while [ "$#" -gt 0 ]; do
            case $1 in
                -h|--help) usage; exit 0 ;;
                -vm|--vmid) VMID="$2"; shift ;;
                -dir|--backup_dir) BACKUP_DIR="$2"; shift ;;
                *) echo "Unknown option: $1"; usage; exit 1 ;;
            esac
            shift
        done
    else
        echo
        usage
        exit 1
    fi

        if ! vm_running; then
            echo "VM: ${VMID} is still running. Aborting process."
            return 1
        fi

        read -r -p "Start full VM backup for VM: ${VMID}? (yes): " start_backup
        if [ "${start_backup}" != "yes" ]; then
            echo "Aborting"
            return 1
        fi

        if ! backup_vm; then
            echo "Backup process failed."
            return 1
        else
            echo "Backup process finished."
            echo "Backup can be found at: ${BACKUP_DIR}/${VMID}"
        fi
}

# Start of logic
USER=$(whoami)
if [ "$USER" != "root" ]; then
    echo "You need to be root."
    exit 1
else
    main "$@"
fi