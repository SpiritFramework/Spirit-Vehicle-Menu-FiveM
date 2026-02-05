
![Vehicle Spawner Banner](https://iili.io/fDZA7vR.png)

# 🚗 Vehicle Spawner

[![Version](https://img.shields.io/badge/version-2.0.0-blue)]()
[![License](https://img.shields.io/badge/license-MIT-yellow)]()
[![FiveM](https://img.shields.io/badge/FiveM-Ready-brightgreen)]()

**Modern, customizable vehicle spawner with NUI interface and automatic update checking.**

---

| Dependency                 | Required   | Description                           |
| -------------------------- | ---------- | ------------------------------------- |
| **Spirit-Notifications** | ✅ Required | For spawn/delete/repair notifications |

---

## 📋 Features

- 🎨 **Modern NUI Interface** — Clean, animated design with categories
- 🏎️ **Organized Categories** — Super, Muscle, Luxury, Off-Road, Motorcycles, Emergency, and more **(Can be changed to your liking)**
- 🔍 **Search Function** — Quickly find vehicles by name
- ⚡ **Auto Update Checker** — GitHub version checking built-in
- 🔔 **Notification Integration** — Works with any notification system
- 🎨 **Fully Customizable** — Colors, position, branding, server logo
- ⌨️ **Keybind Support** — F5 toggle (configurable)
- 🛠️ **Utility Commands** — `/dv` delete vehicle, `/fix` repair vehicle

---

| Command              | Description            | Permission   |
| -------------------- | ---------------------- | ------------ |
| `/car` or `/vehicle` | Open vehicle menu      | Everyone     |
| `/vspawn [model]`    | Spawn specific vehicle | Everyone     |
| `/dv`                | Delete current vehicle | Everyone     |
| `/fix`               | Repair current vehicle | Everyone     |
| `/vcheck`            | Check for updates      | Console/RCON |
| `/vversion`          | Show current version   | Everyone     |

---

## ⚙️ Configuration

### 🚗 Vehicles

Edit the `Vehicles` table in `vehicle_spawner.lua`

```lua
Vehicles = {
    yourcategory = {
        label = "Your Category",
        icon = "🚗",
        color = "#ff0000",
        vehicles = {
            {
                name = "modelname",
                label = "Display Name",
                desc = "Description"
            },
        }
    }
}
```

---

### ⚙️ Basic Settings

Edit the `Config` table in `vehicle_spawner.lua`

```lua
Config = {
    ServerName = "Your Server Name",
    ServerLogo = "https://your-image-url.com/logo.png",

    -- Menu position (screen percentage)
    Position = { x = 95, y = 20 },

    -- Colors & styling
    Style = {
        accentColor = "#ff6b6b",
        backgroundColor = "rgba(15, 15, 15, 0.95)",
        -- See full config in file
    }
}
```

---

## 🚀 Installation

1. **Download** and extract to your resources folder:
