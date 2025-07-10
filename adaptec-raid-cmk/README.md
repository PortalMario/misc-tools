# Description
This script is designed to run as a [local check](https://docs.checkmk.com/latest/en/localchecks.html) script for CheckMk.

# Requirements
**This script is designed to ONLY run on Linux bare-metal servers that are equiped with an Adaptec RAID Controller.**

**The script also requires the official commandline tool to be installed onto the server: [`arcconf`](https://www.microchip.com/en-us/search?searchQuery=arcconf&category=ALL&fq=start%3D0%26rows%3D10)**

**This script was tested and build with arcconf version: `v3.07.23971`**

# Usage
You can execute the script manually:
```shell
bash raid.sh
```

Note: The script is designed as a local check for CheckMK