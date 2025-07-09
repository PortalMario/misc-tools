# Requirements
- **Destination directory with enough space for backups. (Dedicated Logical Volume is recommended!)**
- A secure passphrase to encrypt the backup
- A downtime for the specific VM.
- root access

# Backup File Features
- Full VM Backup in [STOP Mode](https://pve.proxmox.com/wiki/Backup_and_Restore#_backup_modes)
- zstd Compression
- AES256 GPG encryption

# Usage - Create Backup
After the VM is gracefully shutdown login to proxmox host and run the script:
```shell
bash backup.sh -vm XXX -dir /backup
```
### -vm
The ID of the VM.

### -dir
The local directory in which the backups should be stored.
**In it, directories for each vm will be created.**

# Usage - Restore Backup
## Decrypt Backup - Example
The Following command will ask you for your backup decryption password.
```shell
gpg --output vzdump-qemu-106.vma.zst -d vzdump-qemu-106-2025_07_09-16_51_37.vma.zst.gpg
```

**It is important to name the decrypted file correctly like this: `vzdump-qemu-XXX.vma.zst` !** (Like shown in the example above at `--output`)

## Restore VM - Example
```shell
qmrestore vzdump-qemu-106.vma.zst 106
``` 
This will restore the vm with the given vmid. 

## Cleanup
Make sure to delete all uneeded files and clear the gpg cache with:
```shell
rm -r ~/.gnupg
```