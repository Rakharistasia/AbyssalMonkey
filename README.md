# AbyssalMonkey v2.0.0

An automated Abyssal Deadspace runner script for EVE Online using ISXEVE and InnerSpace.

## Description

AbyssalMonkey is a comprehensive automation script designed to run Abyssal Deadspace sites in EVE Online. It handles the complete loop of undocking, activating filaments, clearing rooms, looting, and returning to station for resupply.

This modernized version (v2.0) features a complete rewrite with proper OOP architecture, state machine management, LavishSettings configuration persistence, and a modern LGUI2 user interface.

**Original Code**: Based on work by Kwevin from the isxGames Discord (originally named abyss.iss).

## Features

### Core Automation
- **Full Abyssal Loop**: Undock -> Travel to Site -> Activate Filament -> Clear Rooms -> Loot -> Exit -> Return Home -> Dock -> Unload -> Repeat
- **State Machine Architecture**: Robust state-based control flow with proper transitions
- **Multi-Room Support**: Automatically navigates through all three Abyssal rooms
- **Configurable Loop Count**: Set how many runs to complete before stopping

### Combat
- **Intelligent Targeting**: Prioritizes dangerous NPCs based on threat level
- **Drone Management**: Automatic drone deployment, engagement, and recall
- **Weapon Control**: Automatic weapon activation with target management
- **Module Overheating**: Optional overheating with heat damage monitoring
- **Defensive Modules**: Automatic hardener and prop mod activation
- **Drug Support**: Configurable combat boosters with cooldown tracking

### Inventory Management
- **Ammo Management**: Primary and secondary ammo type support with automatic reloading
- **MTU Deployment**: Optional Mobile Tractor Unit deployment for efficient looting
- **Loot Filtering**: Collects valuable loot while filtering out junk
- **Automatic Unloading**: Deposits loot to hangar or specified container after each run

### Safety Features
- **ISXEVE.IsReady Checks**: Proper initialization before API access
- **Existence Validation**: All object access validated before use
- **Timeout Handling**: Prevents infinite waits on failed operations
- **Error State Recovery**: Graceful handling of unexpected situations
- **Local Safety Checks**: Monitors local for threats before undocking

### User Interface
- **Modern LGUI2 Interface**: Clean, organized settings panels
- **Real-time Status Display**: Current state, loop count, ship status
- **Configuration Persistence**: Settings saved to XML for session continuity
- **Start/Stop/Pause Controls**: Full bot control from UI

## Requirements

### Software
- **InnerSpace** (or ISBoxer with InnerSpace) - https://www.lavishsoft.com/
- **ISXEVE Extension** - EVE Online interface extension for InnerSpace
- **EVE Online** - Active EVE Online client

**Note**: This script currently requires the TEST version of ISXEVE. Install it via the LavishSoft console:
```
ISXEVE:InstallTest
```

### Ship Setup
- Appropriate Abyssal-capable ship (Gila, Hawk, Worm, etc.)
- Fitted weapons appropriate for Abyssal content
- Drones (if using drone-based combat)
- Combat boosters (optional)
- Mobile Tractor Unit (optional)
- Sufficient ammunition and nanite paste (if overheating)

### Bookmarks
- **Home Bookmark**: Station or structure for docking/resupply
- **Site Bookmark**: Safe location for activating filaments (optional)

## Installation

1. **Copy Files**: Place the AbyssalMonkey folder in your InnerSpace Scripts directory:
   ```
   [InnerSpace Directory]\Scripts\AbyssalMonkey\
   ```

2. **File Structure**:
   ```
   AbyssalMonkey/
   ├── AbyssalMonkey.iss     ; Main script
   ├── AbyssalMonkey.json    ; LGUI2 UI definition
   ├── fit.txt               ; Recommended ship fit
   └── README.md             ; This file
   ```

3. **Install Test ISXEVE**:
   ```
   ISXEVE:InstallTest
   ```

4. **Restart**: Close EVE client and launcher, then restart both.

5. **First Run**: The script will create a default configuration file on first run:
   ```
   [InnerSpace Directory]\Settings\AbyssalMonkey.xml
   ```

## Configuration Guide

### Using the UI

1. **Launch the Script**:
   ```
   run AbyssalMonkey/AbyssalMonkey
   ```

2. **Configure Settings**: Use the tabbed interface to configure:

   **Filament Settings**
   - Filament Type: Full name of filament (e.g., "Fierce Exotic Filament")
   - Amount Required: Minimum filaments before running
   - Loop Count: Number of runs to complete

   **Ammo Settings**
   - Primary Ammo: Main ammunition type
   - Secondary Ammo: Fallback ammunition (optional)
   - Amount Required: Minimum ammo before running
   - Range: Optimal engagement range in meters

   **Drone Settings**
   - Use Drones: Enable/disable drone automation
   - Drone Type: Primary drone type name
   - Fallback Type: Secondary drone type (optional)
   - Engagement Range: Maximum drone attack range

   **Drug Settings**
   - Use Drugs: Enable/disable combat boosters
   - Drug 1/2: Names of combat boosters to use

   **MTU Settings**
   - Use MTU: Enable/disable MTU deployment
   - MTU Type: Name of MTU to deploy

   **Overheat Settings**
   - Use Overheat: Enable/disable module overheating
   - HP Threshold: Stop overheating when module HP drops below %
   - Nanite Paste Amount: Required paste for repairs

   **Bookmark Settings**
   - Home Bookmark: Station bookmark for docking
   - Site Bookmark: Location for filament activation

3. **Save Configuration**: Click "Save Configuration" to persist settings

4. **Start the Bot**: Click "Start" to begin automation

### Manual Configuration

Edit `[InnerSpace Directory]\Settings\AbyssalMonkey.xml`:

```xml
<AbyssalMonkey>
    <Config>
        <FilamentType>Fierce Exotic Filament</FilamentType>
        <FilamentAmount>1</FilamentAmount>
        <LoopCount>100</LoopCount>
        <PrimaryAmmo>Scourge Fury Light Missile</PrimaryAmmo>
        <SecondaryAmmo></SecondaryAmmo>
        <AmmoAmount>3000</AmmoAmount>
        <AmmoRange>30000</AmmoRange>
        <UseDrones>TRUE</UseDrones>
        <DroneType>Vespa II</DroneType>
        <FallbackDroneType></FallbackDroneType>
        <DroneRange>80000</DroneRange>
        <UseDrugs>FALSE</UseDrugs>
        <Drug1></Drug1>
        <Drug2></Drug2>
        <UseMTU>FALSE</UseMTU>
        <MTUType>Mobile Tractor Unit</MTUType>
        <UseOverheat>FALSE</UseOverheat>
        <OverheatHPThreshold>15</OverheatHPThreshold>
        <NanitePasteAmount>100</NanitePasteAmount>
        <HomeBookmark>Home</HomeBookmark>
        <AbyssSiteBookmark>Site</AbyssSiteBookmark>
        <LogLevel>3</LogLevel>
    </Config>
</AbyssalMonkey>
```

## Quick Start Guide

1. **Prepare Your Ship**:
   - Fit an Abyssal-capable ship (see fit.txt for recommended fit)
   - Load ammunition
   - Load drones (if applicable)
   - Load filaments
   - Load combat boosters (optional)
   - Load MTU (optional)

2. **Create Bookmarks**:
   - Create a "Home" bookmark at your staging station
   - Optionally create a "Site" bookmark for filament activation

3. **Weapon Setup** (for missiles):
   - Make sure your first 4 slots are the launchers
   - Combine/group the launchers starting from the first slot

4. **Dock at Home Station**:
   - The bot starts from docked state

5. **Launch Script**:
   ```
   run AbyssalMonkey/AbyssalMonkey
   ```

6. **Configure via UI**:
   - Set filament type to match your cargo
   - Set ammo type to match your weapons
   - Set drone type if using drones
   - Make sure missile and drone range settings match
   - Click "Save Configuration"

7. **Start the Bot**:
   - Click "Start"
   - Monitor the status display
   - Use "Pause" to temporarily halt operations
   - Use "Stop" to end the bot gracefully

## Supported Ship Fits

AbyssalMonkey is designed to work with various Abyssal-capable ships. See `fit.txt` for the recommended fit including implants.

### Missile Ships
- **Gila** (Heavy Assault Cruiser) - Popular choice for T3-T5
- **Hawk** (Assault Frigate) - T1-T3 electrical/exotic
- **Worm** (Frigate) - T1-T2 sites
- **Caracal Navy Issue** - Budget T3-T4 option

### Drone Ships
- **Gila** - Primary damage from drones
- **Ishtar** - Heavy drone platform
- **Worm** - Light drone support

### Weapon Types Supported
- Light/Heavy/Rapid Light Missiles
- Drones (Light, Medium, Heavy)
- Hybrid Turrets (with appropriate configuration)
- Projectile Turrets (with appropriate configuration)

**Note**: Currently optimized for passive shield fits.

## Troubleshooting

### Script Won't Start
- Verify ISXEVE is loaded: Check for "ISXEVE" in console
- Ensure you have TEST version: `ISXEVE:InstallTest`
- Ensure EVE is running and logged in
- Check that you're docked at a station

### Bot Gets Stuck
- Check the status display for current state
- Verify bookmarks exist and are correctly named
- Ensure cargo has required items (filaments, ammo)
- Check for error messages in InnerSpace console

### Drones Not Working
- Verify drone names match exactly (case-sensitive)
- Ensure drones are in drone bay
- Check DroneRange setting is appropriate

### Weapons Not Firing
- Verify ammo names match exactly (case-sensitive)
- Ensure weapons are loaded
- Check AmmoRange setting
- For missiles: ensure launchers are in slots 0-3 and grouped on slot 0

### MTU Issues
- Verify MTU name matches exactly
- Ensure MTU is in cargo
- Check that MTU isn't already deployed

### After EVE Patch
- Wait for Cyber to update the test version of ISXEVE (may take a couple days)
- Reinstall test version: `ISXEVE:InstallTest`
- Restart EVE client and launcher

### Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "ISXEVE not ready" | Extension not loaded | Wait for ISXEVE to initialize |
| "Insufficient filaments" | No filaments in cargo | Restock filaments |
| "Insufficient ammo" | Low ammunition | Restock ammunition |
| "Home bookmark not found" | Missing bookmark | Create "Home" bookmark |
| "Cannot activate in station" | Tried to run while docked | Script handles this automatically |

### Debug Mode

Enable debug logging for detailed output:
1. Set LogLevel to 4 (DEBUG) in configuration
2. Monitor InnerSpace console for detailed state information

## Version History

### v2.0.0 (Current)
- Complete architectural rewrite with OOP design
- State machine with proper state queue
- LavishSettings configuration persistence
- LGUI2 modern UI
- Drug cooldown tracking
- MTU deployment support
- Module overheating support
- Improved drone management
- Proper ISXEVE safety checks
- Event-driven pulse architecture

### v1.x (Legacy)
- Original procedural implementation by Kwevin
- Basic Abyssal running functionality
- Multiple updates and improvements

## Architecture

### Object Definitions

- **obj_AbyssalConfig**: Configuration management with XML persistence
- **obj_Logger**: Configurable logging system (CRITICAL/WARNING/INFO/DEBUG)
- **obj_StateQueue**: State machine management with queue operations
- **obj_AbyssalMonkey**: Main bot controller with all automation logic

### States

1. IDLE - Waiting for start command
2. CHECK_STATUS - Verify requirements before undocking
3. REPAIR - Repair damaged modules (if needed)
4. RELOAD_SUPPLIES - Restock ammo/drones/filaments
5. UNDOCK - Leave station
6. GO_TO_SITE - Warp to filament activation location
7. ACTIVATE_FILAMENT - Use filament to enter Abyssal
8. WAIT_FOR_ABYSS - Wait for Abyssal space transition
9. RUN_SITE - Main site running state
10. CLEAR_ROOM - Combat phase
11. LOOT_ROOM - Collect loot
12. NEXT_ROOM - Navigate to next room
13. EXIT_ABYSS - Leave through final gate
14. RETURN_HOME - Warp to home station
15. DOCK - Dock at station
16. UNLOAD_LOOT - Transfer loot to hangar
17. ERROR - Error handling state

## Credits

- **Original Code**: Kwevin (isxGames Discord)
- **Modernization**: Claude AI
- **ISXEVE**: Lavish Software
- **EVE Online**: CCP Games

## License

This script is provided as-is for educational and personal use. Use at your own risk. Automated gameplay may violate EVE Online's Terms of Service.

## Disclaimer

This script automates gameplay in EVE Online. Use of automation tools may result in account action by CCP Games. The authors are not responsible for any consequences resulting from the use of this script. Always review and understand EVE Online's EULA and Terms of Service before using automation tools.
