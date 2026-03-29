# 🖥️ homelab-pve-tools

Utilities for managing Proxmox LXC containers in a homelab environment.

This repository provides a centralized way to:

- Discover LXC containers with update capabilities
- Check for Docker image updates across containers
- Update containers individually, in bulk, or interactively

## ✨ Features

- 🔍 Auto-discovery of update-capable containers
- 📦 Docker Compose update management inside LXCs
- 📊 Update status per container (up-to-date / update available)
- 🎯 Update:
  - single container
  - multiple containers
  - all containers
- 🧠 Interactive selection (`whiptail`)
- 🚫 Ignore list support
- ⚙️ Configurable behavior via config file

## 📁 Structure

```
bin/        # Main executable scripts (ctupdate)
install/    # Install helpers
examples/   # Example configuration files
```

## 🚀 Installation

```bash
git clone https://github.com/themrwookiee/homelab-pve-tools /opt/homelab/homelab-pve-tools
cd /opt/homelab/homelab-pve-tools

bash install/install-pve-scripts.sh
```

## ⚙️ Configuration

Config file:

```
/etc/ctupdate/ctupdate.conf
```

Example:

```bash
MANAGED_LIST="/etc/ctupdate/managed_cts.conf"
IGNORE_FILE="/etc/ctupdate/ignore.conf"
UPDATE_SCRIPT_PATH="/usr/local/bin/update"
CHECK_SCRIPT_PATH="/usr/local/bin/check-updates"
RUNNING_ONLY="true"
INTERACTIVE_CMD="whiptail"
```

Optional ignore file:

```
/etc/ctupdate/ignore.conf
```

Example:

```
100
9000
```

## 📌 Usage

### 🔍 Discover containers & check updates

```bash
ctupdate list
```

### 🎯 Interactive update selection

```bash
ctupdate list -i
```

### 🚀 Update all containers

```bash
ctupdate all
```

### 🎯 Update specific containers

```bash
ctupdate 203 204 205
```

## 🧠 How it works

- Uses `pct` to interact with Proxmox LXCs
- Calls scripts inside containers:
  - `/usr/local/bin/update`
  - `/usr/local/bin/check-updates`
- Displays update status per service

## 📦 Requirements

- Proxmox VE
- `pct` available on host
- `bash`
- `whiptail` (optional, for interactive mode)
