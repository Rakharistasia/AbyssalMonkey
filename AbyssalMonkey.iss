; AbyssalMonkey v2.0.0
; Modernized Abyssal Runner Script
; Original Author: Unknown | Modernization: Claude AI
;
; Complete rewrite with proper OOP architecture, state management,
; LavishSettings configuration, and comprehensive feature set.

; ============================================================================
; CONSTANTS
; ============================================================================

#define LOG_CRITICAL    1
#define LOG_WARNING     2
#define LOG_INFO        3
#define LOG_DEBUG       4

#define MOVE_STOPPED    0
#define MOVE_MOVING     1
#define MOVE_APPROACHING 2
#define MOVE_WARPING    3
#define MOVE_ORBITING   4

#define GROUP_ABYSSAL_SHIP      "Abyssal Spaceship Entities"
#define GROUP_ABYSSAL_DRONE     "Abyssal Drone Entities"
#define GROUP_MOBILE_TRACTOR    "Mobile Tractor Unit"
#define GROUP_WRECK             462

#define CATEGORY_ASTEROID       25
#define CATEGORY_SHIP           6
#define CATEGORY_STRUCTURE      23

#define DEFAULT_PULSE_FREQUENCY     2000
#define WARP_WAIT_TIMEOUT           120000
#define DOCK_WAIT_TIMEOUT           60000
#define LOCK_WAIT_TIMEOUT           30000
#define MODULE_ACTIVATION_DELAY     1000
#define LOOT_APPROACH_DISTANCE      2000
#define GATE_APPROACH_DISTANCE      2500
#define DEFAULT_ORBIT_DISTANCE      10000

#define SHIELD_DRUG_THRESHOLD       40
#define ARMOR_DRUG_THRESHOLD        40
#define LOW_CAPACITOR_THRESHOLD     20
#define CRITICAL_SHIELD_THRESHOLD   25
#define OVERHEAT_HP_THRESHOLD       15

; ============================================================================
; CONFIGURATION OBJECT DEFINITION
; ============================================================================

objectdef obj_AbyssalConfig
{
    variable settingsetref ConfigRef

    method Initialize()
    {
        This:LoadDefaults
        This:LoadFromSettings
    }

    method LoadDefaults()
    {
        ; Filament settings
        FilamentType:Set["Fierce Exotic Filament"]
        FilamentAmount:Set[1]
        LoopCount:Set[100]

        ; Ammo settings
        PrimaryAmmo:Set["Scourge Fury Light Missile"]
        SecondaryAmmo:Set[""]
        AmmoAmount:Set[3000]
        AmmoRange:Set[30000]

        ; Drone settings
        UseDrones:Set[TRUE]
        DroneType:Set["Vespa II"]
        FallbackDroneType:Set[""]
        DroneRange:Set[80000]

        ; Drug settings
        UseDrugs:Set[FALSE]
        Drug1:Set[""]
        Drug2:Set[""]

        ; MTU settings
        UseMTU:Set[FALSE]
        MTUType:Set["Mobile Tractor Unit"]

        ; Overheat settings
        UseOverheat:Set[FALSE]
        OverheatHPThreshold:Set[15]
        NanitePasteAmount:Set[100]

        ; Bookmark settings
        HomeBookmark:Set["Home"]
        AbyssSiteBookmark:Set["Site"]

        ; Module slot configuration
        PropModSlot:Set[0]
        Hardener1Slot:Set[1]
        Hardener2Slot:Set[-1]
        WeaponSlots:Set["0,1,2,3"]

        ; Logging
        LogLevel:Set[LOG_INFO]

        ; Storage settings
        UseCorpHangar:Set[FALSE]
        CorpHangarFolder:Set[""]
        DropOffContainer:Set[""]
    }

    method LoadFromSettings()
    {
        LavishSettings[AbyssalMonkey]:Clear
        LavishSettings:AddSet[AbyssalMonkey]

        if ${LavishSettings[AbyssalMonkey].FindSet[Config](exists)}
        {
            This.ConfigRef:Set[${LavishSettings[AbyssalMonkey].FindSet[Config]}]

            ; Load each setting if it exists
            if ${This.ConfigRef.FindSetting[FilamentType](exists)}
            {
                FilamentType:Set[${This.ConfigRef.FindSetting[FilamentType]}]
            }
            if ${This.ConfigRef.FindSetting[FilamentAmount](exists)}
            {
                FilamentAmount:Set[${This.ConfigRef.FindSetting[FilamentAmount]}]
            }
            if ${This.ConfigRef.FindSetting[LoopCount](exists)}
            {
                LoopCount:Set[${This.ConfigRef.FindSetting[LoopCount]}]
            }
            if ${This.ConfigRef.FindSetting[PrimaryAmmo](exists)}
            {
                PrimaryAmmo:Set[${This.ConfigRef.FindSetting[PrimaryAmmo]}]
            }
            if ${This.ConfigRef.FindSetting[SecondaryAmmo](exists)}
            {
                SecondaryAmmo:Set[${This.ConfigRef.FindSetting[SecondaryAmmo]}]
            }
            if ${This.ConfigRef.FindSetting[AmmoAmount](exists)}
            {
                AmmoAmount:Set[${This.ConfigRef.FindSetting[AmmoAmount]}]
            }
            if ${This.ConfigRef.FindSetting[AmmoRange](exists)}
            {
                AmmoRange:Set[${This.ConfigRef.FindSetting[AmmoRange]}]
            }
            if ${This.ConfigRef.FindSetting[UseDrones](exists)}
            {
                UseDrones:Set[${This.ConfigRef.FindSetting[UseDrones]}]
            }
            if ${This.ConfigRef.FindSetting[DroneType](exists)}
            {
                DroneType:Set[${This.ConfigRef.FindSetting[DroneType]}]
            }
            if ${This.ConfigRef.FindSetting[FallbackDroneType](exists)}
            {
                FallbackDroneType:Set[${This.ConfigRef.FindSetting[FallbackDroneType]}]
            }
            if ${This.ConfigRef.FindSetting[DroneRange](exists)}
            {
                DroneRange:Set[${This.ConfigRef.FindSetting[DroneRange]}]
            }
            if ${This.ConfigRef.FindSetting[UseDrugs](exists)}
            {
                UseDrugs:Set[${This.ConfigRef.FindSetting[UseDrugs]}]
            }
            if ${This.ConfigRef.FindSetting[Drug1](exists)}
            {
                Drug1:Set[${This.ConfigRef.FindSetting[Drug1]}]
            }
            if ${This.ConfigRef.FindSetting[Drug2](exists)}
            {
                Drug2:Set[${This.ConfigRef.FindSetting[Drug2]}]
            }
            if ${This.ConfigRef.FindSetting[UseMTU](exists)}
            {
                UseMTU:Set[${This.ConfigRef.FindSetting[UseMTU]}]
            }
            if ${This.ConfigRef.FindSetting[MTUType](exists)}
            {
                MTUType:Set[${This.ConfigRef.FindSetting[MTUType]}]
            }
            if ${This.ConfigRef.FindSetting[UseOverheat](exists)}
            {
                UseOverheat:Set[${This.ConfigRef.FindSetting[UseOverheat]}]
            }
            if ${This.ConfigRef.FindSetting[OverheatHPThreshold](exists)}
            {
                OverheatHPThreshold:Set[${This.ConfigRef.FindSetting[OverheatHPThreshold]}]
            }
            if ${This.ConfigRef.FindSetting[NanitePasteAmount](exists)}
            {
                NanitePasteAmount:Set[${This.ConfigRef.FindSetting[NanitePasteAmount]}]
            }
            if ${This.ConfigRef.FindSetting[HomeBookmark](exists)}
            {
                HomeBookmark:Set[${This.ConfigRef.FindSetting[HomeBookmark]}]
            }
            if ${This.ConfigRef.FindSetting[AbyssSiteBookmark](exists)}
            {
                AbyssSiteBookmark:Set[${This.ConfigRef.FindSetting[AbyssSiteBookmark]}]
            }
            if ${This.ConfigRef.FindSetting[LogLevel](exists)}
            {
                LogLevel:Set[${This.ConfigRef.FindSetting[LogLevel]}]
            }
        }
    }

    method Save()
    {
        LavishSettings[AbyssalMonkey]:AddSet[Config]
        This.ConfigRef:Set[${LavishSettings[AbyssalMonkey].FindSet[Config]}]

        This.ConfigRef:AddSetting[FilamentType, ${FilamentType}]
        This.ConfigRef:AddSetting[FilamentAmount, ${FilamentAmount}]
        This.ConfigRef:AddSetting[LoopCount, ${LoopCount}]
        This.ConfigRef:AddSetting[PrimaryAmmo, ${PrimaryAmmo}]
        This.ConfigRef:AddSetting[SecondaryAmmo, ${SecondaryAmmo}]
        This.ConfigRef:AddSetting[AmmoAmount, ${AmmoAmount}]
        This.ConfigRef:AddSetting[AmmoRange, ${AmmoRange}]
        This.ConfigRef:AddSetting[UseDrones, ${UseDrones}]
        This.ConfigRef:AddSetting[DroneType, ${DroneType}]
        This.ConfigRef:AddSetting[FallbackDroneType, ${FallbackDroneType}]
        This.ConfigRef:AddSetting[DroneRange, ${DroneRange}]
        This.ConfigRef:AddSetting[UseDrugs, ${UseDrugs}]
        This.ConfigRef:AddSetting[Drug1, ${Drug1}]
        This.ConfigRef:AddSetting[Drug2, ${Drug2}]
        This.ConfigRef:AddSetting[UseMTU, ${UseMTU}]
        This.ConfigRef:AddSetting[MTUType, ${MTUType}]
        This.ConfigRef:AddSetting[UseOverheat, ${UseOverheat}]
        This.ConfigRef:AddSetting[OverheatHPThreshold, ${OverheatHPThreshold}]
        This.ConfigRef:AddSetting[NanitePasteAmount, ${NanitePasteAmount}]
        This.ConfigRef:AddSetting[HomeBookmark, ${HomeBookmark}]
        This.ConfigRef:AddSetting[AbyssSiteBookmark, ${AbyssSiteBookmark}]
        This.ConfigRef:AddSetting[LogLevel, ${LogLevel}]

        LavishSettings[AbyssalMonkey]:Export["${LavishScript.HomeDirectory}/Scripts/AbyssalMonkey/AbyssalMonkey_Config.xml"]
    }

    ; Configuration properties
    variable string FilamentType
    variable int FilamentAmount
    variable int LoopCount
    variable string PrimaryAmmo
    variable string SecondaryAmmo
    variable int AmmoAmount
    variable int AmmoRange
    variable bool UseDrones
    variable string DroneType
    variable string FallbackDroneType
    variable int DroneRange
    variable bool UseDrugs
    variable string Drug1
    variable string Drug2
    variable bool UseMTU
    variable string MTUType
    variable bool UseOverheat
    variable int OverheatHPThreshold
    variable int NanitePasteAmount
    variable string HomeBookmark
    variable string AbyssSiteBookmark
    variable int PropModSlot
    variable int Hardener1Slot
    variable int Hardener2Slot
    variable string WeaponSlots
    variable int LogLevel
    variable bool UseCorpHangar
    variable string CorpHangarFolder
    variable string DropOffContainer
}

; ============================================================================
; LOGGER OBJECT DEFINITION
; ============================================================================

objectdef obj_Logger
{
    variable int LogLevelThreshold = LOG_INFO

    method SetLogLevel(int level)
    {
        This.LogLevelThreshold:Set[${level}]
    }

    method Log(string message, int level = LOG_INFO, string color = "w")
    {
        if ${level} <= ${This.LogLevelThreshold}
        {
            variable string prefix = ""
            switch ${level}
            {
                case ${LOG_CRITICAL}
                    prefix:Set["[CRITICAL]"]
                    color:Set["r"]
                    break
                case ${LOG_WARNING}
                    prefix:Set["[WARNING]"]
                    color:Set["o"]
                    break
                case ${LOG_INFO}
                    prefix:Set["[INFO]"]
                    break
                case ${LOG_DEBUG}
                    prefix:Set["[DEBUG]"]
                    color:Set["g"]
                    break
            }
            echo "\a${color}AbyssalMonkey ${prefix} ${message}\ax"
        }
    }

    method Critical(string message)
    {
        This:Log["${message}", LOG_CRITICAL]
    }

    method Warning(string message)
    {
        This:Log["${message}", LOG_WARNING]
    }

    method Info(string message)
    {
        This:Log["${message}", LOG_INFO]
    }

    method Debug(string message)
    {
        This:Log["${message}", LOG_DEBUG]
    }
}

; ============================================================================
; STATE QUEUE OBJECT DEFINITION
; ============================================================================

objectdef obj_StateQueue
{
    variable collection:string StateQueue
    variable string CurrentState = "IDLE"
    variable int StateStartTime = 0
    variable int PulseFrequency = DEFAULT_PULSE_FREQUENCY
    variable int NextPulseTime = 0

    method QueueState(string stateName, int delay = 0)
    {
        This.StateQueue:Set["${stateName}", "${delay}"]
        Logger:Debug["Queued state: ${stateName} with delay ${delay}ms"]
    }

    method InsertState(string stateName, int delay = 0)
    {
        ; Insert at front of queue by setting current state
        This.CurrentState:Set["${stateName}"]
        This.StateStartTime:Set[${LavishScript.RunningTime}]
        Logger:Debug["Inserted state: ${stateName}"]
    }

    method SetState(string stateName)
    {
        This.CurrentState:Set["${stateName}"]
        This.StateStartTime:Set[${LavishScript.RunningTime}]
        Logger:Info["State changed to: ${stateName}"]
    }

    member:int StateElapsedTime()
    {
        return ${Math.Calc[${LavishScript.RunningTime} - ${This.StateStartTime}]}
    }

    member:bool IsIdle()
    {
        return ${This.CurrentState.Equal["IDLE"]}
    }

    method Clear()
    {
        This.StateQueue:Clear
        This.CurrentState:Set["IDLE"]
    }
}

; ============================================================================
; MAIN BOT OBJECT DEFINITION
; ============================================================================

objectdef obj_AbyssalMonkey
{
    ; Core components
    variable obj_AbyssalConfig Config
    variable obj_StateQueue StateManager

    ; Runtime state
    variable bool IsRunning = FALSE
    variable bool IsPaused = FALSE
    variable int CurrentLoop = 0
    variable int NextPulseTime = 0

    ; Timing for drugs (cooldown tracking)
    variable int HardshellCooldown = 0
    variable int BluePillCooldown = 0
    variable int ExileCooldown = 0

    ; Combat state
    variable bool HasGrabbedLoot = FALSE
    variable bool ShouldAbandonMTU = FALSE
    variable bool IsOverheatSetup = FALSE

    ; Status flags
    variable bool StatusChecked = FALSE
    variable bool StatusGreen = FALSE

    ; ========================================================================
    ; INITIALIZATION
    ; ========================================================================

    method Initialize()
    {
        Logger:Info["AbyssalMonkey v2.0.0 Initializing..."]

        ; Attach to frame event for pulse-based operation
        Event[ISXEVE_onFrame]:AttachAtom[This:Pulse]

        ; Load UI
        LGUI2:LoadPackageFile["${LavishScript.HomeDirectory}/Scripts/AbyssalMonkey/AbyssalMonkey.json"]

        Logger:SetLogLevel[${This.Config.LogLevel}]
        Logger:Info["Initialization complete. Ready to run."]
    }

    method Shutdown()
    {
        Logger:Info["Shutting down AbyssalMonkey..."]

        Event[ISXEVE_onFrame]:DetachAtom[This:Pulse]
        LGUI2:UnloadPackageFile["${LavishScript.HomeDirectory}/Scripts/AbyssalMonkey/AbyssalMonkey.json"]

        This.Config:Save
        Logger:Info["Shutdown complete."]
    }

    ; ========================================================================
    ; MAIN PULSE (EVENT-DRIVEN)
    ; ========================================================================

    method Pulse()
    {
        ; Skip if paused or not running
        if ${This.IsPaused} || !${This.IsRunning}
        {
            return
        }

        ; Throttle pulse rate
        if ${LavishScript.RunningTime} < ${This.NextPulseTime}
        {
            return
        }

        ; Safety checks
        if !${ISXEVE.IsReady} || !${Me(exists)} || !${MyShip(exists)}
        {
            return
        }

        ; Schedule next pulse with jitter
        This.NextPulseTime:Set[${Math.Calc[${LavishScript.RunningTime} + ${DEFAULT_PULSE_FREQUENCY} + ${Math.Rand[500]}]}]

        ; Process current state
        This:ProcessState
    }

    ; ========================================================================
    ; STATE MACHINE
    ; ========================================================================

    method ProcessState()
    {
        switch ${This.StateManager.CurrentState}
        {
            case IDLE
                This:State_Idle
                break
            case CHECK_STATUS
                This:State_CheckStatus
                break
            case REPAIR
                This:State_Repair
                break
            case RELOAD_SUPPLIES
                This:State_ReloadSupplies
                break
            case UNDOCK
                This:State_Undock
                break
            case GO_TO_SITE
                This:State_GoToSite
                break
            case ACTIVATE_FILAMENT
                This:State_ActivateFilament
                break
            case WAIT_FOR_ABYSS
                This:State_WaitForAbyss
                break
            case RUN_SITE
                This:State_RunSite
                break
            case CLEAR_ROOM
                This:State_ClearRoom
                break
            case LOOT_ROOM
                This:State_LootRoom
                break
            case NEXT_ROOM
                This:State_NextRoom
                break
            case EXIT_ABYSS
                This:State_ExitAbyss
                break
            case RETURN_HOME
                This:State_ReturnHome
                break
            case DOCK
                This:State_Dock
                break
            case UNLOAD_LOOT
                This:State_UnloadLoot
                break
            case ERROR
                This:State_Error
                break
            default
                Logger:Warning["Unknown state: ${This.StateManager.CurrentState}"]
                This.StateManager:SetState["IDLE"]
        }
    }

    ; ========================================================================
    ; STATE IMPLEMENTATIONS
    ; ========================================================================

    method State_Idle()
    {
        ; Check if we should start a new run
        if ${This.CurrentLoop} >= ${This.Config.LoopCount}
        {
            Logger:Info["Completed ${This.CurrentLoop} runs. Stopping."]
            This:Stop
            return
        }

        ; Determine next action based on location
        if ${Me.InStation}
        {
            if !${This.StatusChecked}
            {
                This.StateManager:SetState["CHECK_STATUS"]
            }
            elseif !${This.StatusGreen}
            {
                This.StateManager:SetState["RELOAD_SUPPLIES"]
            }
            else
            {
                This.StateManager:SetState["UNDOCK"]
            }
        }
        elseif ${Me.InSpace}
        {
            if ${This.IsInAbyss}
            {
                This.StateManager:SetState["RUN_SITE"]
            }
            elseif !${This.StatusChecked}
            {
                This.StateManager:SetState["CHECK_STATUS"]
            }
            elseif !${This.StatusGreen}
            {
                This.StateManager:SetState["RETURN_HOME"]
            }
            else
            {
                This.StateManager:SetState["GO_TO_SITE"]
            }
        }
    }

    method State_CheckStatus()
    {
        Logger:Info["Checking status..."]

        This.StatusGreen:Set[TRUE]

        ; Check ammo levels
        if !${This.HasSufficientAmmo}
        {
            Logger:Info["Short on ammo"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check drone bay
        if ${This.Config.UseDrones} && !${This.HasSufficientDrones}
        {
            Logger:Info["Short on drones"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check filaments
        if !${This.HasFilament}
        {
            Logger:Info["No filament available"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check MTU
        if ${This.Config.UseMTU} && !${This.HasMTU}
        {
            Logger:Info["No MTU available"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check drugs
        if ${This.Config.UseDrugs} && !${This.HasDrugs}
        {
            Logger:Info["Short on drugs"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check nanite paste for overheating
        if ${This.Config.UseOverheat} && !${This.HasNanitePaste}
        {
            Logger:Info["Short on nanite paste"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check ship damage
        if ${MyShip.StructurePct} < 100 || ${MyShip.Module[HiSlot0].Damage} > 25
        {
            Logger:Info["Ship needs repair"]
            This.StatusGreen:Set[FALSE]
        }

        ; Check cargo space
        if ${Me.InSpace}
        {
            if ${EVEWindow[Inventory](exists)} && ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo](exists)}
            {
                variable float freeSpace = ${Math.Calc[${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo].Capacity} - ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo].UsedCapacity}]}
                if ${freeSpace} < 100
                {
                    Logger:Info["Cargo nearly full"]
                    This.StatusGreen:Set[FALSE]
                }
            }
        }

        This.StatusChecked:Set[TRUE]
        This.StateManager:SetState["IDLE"]
    }

    method State_Repair()
    {
        if !${Me.InStation}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        Logger:Info["Repairing ship..."]

        ; Use repair shop
        if ${MyShip.StructurePct} < 100 || ${MyShip.ArmorPct} < 100
        {
            MyShip.ToItem:GetRepairQuote
            wait 20

            if ${EVEWindow[Repairshop](exists)}
            {
                EVEWindow[Repairshop].Button[2]:Press
                wait 20
                EVEWindow[Repairshop]:Close
            }
        }

        This.StateManager:SetState["IDLE"]
    }

    method State_ReloadSupplies()
    {
        if !${Me.InStation}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        Logger:Info["Reloading supplies..."]

        ; Ensure inventory is open
        if !${EVEWindow[Inventory](exists)}
        {
            EVE:Execute[OpenInventory]
            return
        }

        ; Load ammo
        call This.LoadItem "${This.Config.PrimaryAmmo}" ${This.Config.AmmoAmount} "ShipCargo"

        if ${This.Config.SecondaryAmmo.NotNULLOrEmpty}
        {
            call This.LoadItem "${This.Config.SecondaryAmmo}" ${This.Config.AmmoAmount} "ShipCargo"
        }

        ; Load filaments
        call This.LoadItem "${This.Config.FilamentType}" ${This.Config.FilamentAmount} "ShipCargo"

        ; Load drones
        if ${This.Config.UseDrones}
        {
            call This.LoadDrones
        }

        ; Load MTU
        if ${This.Config.UseMTU}
        {
            call This.LoadItem "${This.Config.MTUType}" 1 "ShipCargo"
        }

        ; Load drugs
        if ${This.Config.UseDrugs}
        {
            if ${This.Config.Drug1.NotNULLOrEmpty}
            {
                call This.LoadItem "${This.Config.Drug1}" 2 "ShipCargo"
            }
            if ${This.Config.Drug2.NotNULLOrEmpty}
            {
                call This.LoadItem "${This.Config.Drug2}" 2 "ShipCargo"
            }
        }

        ; Load nanite paste
        if ${This.Config.UseOverheat}
        {
            call This.LoadItem "Nanite Repair Paste" ${This.Config.NanitePasteAmount} "ShipCargo"
        }

        This.StatusGreen:Set[TRUE]
        This.StateManager:SetState["IDLE"]
    }

    method State_Undock()
    {
        if !${Me.InStation}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Check local before undocking
        if !${This.IsLocalSafe}
        {
            Logger:Warning["Hostiles in local, waiting..."]
            return
        }

        Logger:Info["Undocking..."]
        EVE:Execute[CmdExitStation]

        ; Wait for undock
        variable int timeout = ${Math.Calc[${LavishScript.RunningTime} + ${DOCK_WAIT_TIMEOUT}]}
        while ${Me.InStation} && ${LavishScript.RunningTime} < ${timeout}
        {
            waitframe
        }

        if ${Me.InSpace}
        {
            wait 50
            This.StateManager:SetState["IDLE"]
        }
    }

    method State_GoToSite()
    {
        if !${Me.InSpace}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Check local
        if !${This.IsLocalSafe}
        {
            Logger:Warning["Hostiles in local, docking..."]
            This.StateManager:SetState["RETURN_HOME"]
            return
        }

        Logger:Info["Warping to abyss site..."]

        ; Find bookmark and warp
        variable index:bookmark bookmarks
        EVE:GetBookmarks[bookmarks]

        variable int i
        for (i:Set[1]; ${i} <= ${bookmarks.Used}; i:Inc)
        {
            if ${bookmarks.Get[${i}](exists)} && ${bookmarks.Get[${i}].Label.Equal[${This.Config.AbyssSiteBookmark}]}
            {
                if ${bookmarks.Get[${i}].JumpsTo} == 0
                {
                    bookmarks.Get[${i}]:WarpTo[0]
                    break
                }
            }
        }

        ; Wait for warp to complete
        wait 100
        while ${MyShip.ToEntity.Mode} == MOVE_WARPING
        {
            wait 10
        }

        This.StateManager:SetState["ACTIVATE_FILAMENT"]
    }

    method State_ActivateFilament()
    {
        if !${Me.InSpace}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        Logger:Info["Activating filament..."]

        ; Check for existing trace
        if ${Entity[Name == "Abyssal Trace" && Distance < 10000](exists)}
        {
            Logger:Info["Entering existing trace..."]
            Entity[Name == "Abyssal Trace" && Distance < 10000]:Activate
            This.StateManager:SetState["WAIT_FOR_ABYSS"]
            return
        }

        ; Use filament from cargo
        if ${EVEWindow[Inventory](exists)}
        {
            variable index:item cargoItems
            EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

            variable int i
            for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
            {
                if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Name.Equal[${This.Config.FilamentType}]}
                {
                    cargoItems.Get[${i}]:UseAbyssalFilament
                    wait 30

                    ; Click confirmation button
                    if ${EVEWindow[KeyActivationWindow](exists)}
                    {
                        EVEWindow[KeyActivationWindow].Button[1]:Press
                    }
                    break
                }
            }
        }

        This.StateManager:SetState["WAIT_FOR_ABYSS"]
    }

    method State_WaitForAbyss()
    {
        ; Wait for abyss entry
        wait 50

        if ${This.IsInAbyss}
        {
            Logger:Info["Entered Abyss!"]
            This.CurrentLoop:Inc
            This.HasGrabbedLoot:Set[FALSE]
            This.ShouldAbandonMTU:Set[FALSE]
            This.StateManager:SetState["RUN_SITE"]
        }
        elseif ${This.StateManager.StateElapsedTime} > 30000
        {
            Logger:Warning["Failed to enter abyss, retrying..."]
            This.StateManager:SetState["ACTIVATE_FILAMENT"]
        }
    }

    method State_RunSite()
    {
        if !${This.IsInAbyss}
        {
            This.StatusChecked:Set[FALSE]
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Close any confirmation windows
        if ${EVEWindow[KeyActivationWindow](exists)}
        {
            EVEWindow[KeyActivationWindow]:Close
        }

        ; Cancel weapon repair if overheating
        if ${This.Config.UseOverheat} && ${MyShip.Module[HiSlot0].IsBeingRepaired}
        {
            MyShip.Module[HiSlot0]:CancelRepair
        }

        ; Check for enemies
        if ${This.HasEnemiesPresent}
        {
            This.StateManager:SetState["CLEAR_ROOM"]
        }
        else
        {
            This.StateManager:SetState["LOOT_ROOM"]
        }
    }

    method State_ClearRoom()
    {
        if !${This.IsInAbyss}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Use drugs if taking damage
        This:ConsumeDrugsIfNeeded

        ; Activate defense modules
        This:ActivateDefensiveModules

        ; Launch drones
        if ${This.Config.UseDrones}
        {
            This:ManageDrones
        }

        ; Deploy MTU if configured
        if ${This.Config.UseMTU} && !${This.ShouldAbandonMTU}
        {
            This:DeployMTUIfNeeded
        }

        ; Manage targeting and weapons
        This:ManageTargeting
        This:ActivateWeapons

        ; Navigation during combat
        This:NavigateDuringCombat

        ; Check if room is clear
        if !${This.HasEnemiesPresent}
        {
            Logger:Info["Room cleared!"]
            This.HasGrabbedLoot:Set[FALSE]
            This.StateManager:SetState["LOOT_ROOM"]
        }
    }

    method State_LootRoom()
    {
        if !${This.IsInAbyss}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Reload weapons
        EVE:Execute[CmdReloadAmmo]

        ; Repair overheated modules
        if ${This.Config.UseOverheat}
        {
            This:RepairOverheatedModules
        }

        ; Wait for MTU if configured
        if ${This.Config.UseMTU} && ${This.IsMTUDeployed} && !${This.ShouldAbandonMTU}
        {
            if ${This.HasLootableWrecks}
            {
                ; Approach MTU
                if ${Entity[Group =- "Mobile Tractor Unit"](exists)}
                {
                    if ${Entity[Group =- "Mobile Tractor Unit"].Distance} > LOOT_APPROACH_DISTANCE
                    {
                        Entity[Group =- "Mobile Tractor Unit"]:Approach
                        return
                    }
                }
                return
            }
            else
            {
                ; Scoop MTU
                call This.ScoopMTU
            }
        }
        elseif !${This.Config.UseMTU} || ${This.ShouldAbandonMTU}
        {
            ; Loot wreck manually
            if ${Entity[Name =- "Cache Wreck" && !IsWreckEmpty](exists)}
            {
                if ${Entity[Name =- "Cache Wreck"].Distance} > LOOT_APPROACH_DISTANCE
                {
                    Entity[Name =- "Cache Wreck"]:Approach
                    return
                }
                else
                {
                    Entity[Name =- "Cache Wreck"]:Open
                    wait 20
                    EVEWindow[Inventory]:LootAll
                    This.HasGrabbedLoot:Set[TRUE]
                }
            }
        }

        ; Move to next room or exit
        if ${This.HasGrabbedLoot} || !${This.HasLootableWrecks}
        {
            This.StateManager:SetState["NEXT_ROOM"]
        }
    }

    method State_NextRoom()
    {
        if !${This.IsInAbyss}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        ; Find conduit
        variable entity conduit
        if ${Entity[Name == "Transfer Conduit (Triglavian)"](exists)}
        {
            conduit:Set[${Entity[Name == "Transfer Conduit (Triglavian)"]}]
            Logger:Info["Approaching transfer conduit..."]
        }
        elseif ${Entity[Name == "Origin Conduit (Triglavian)"](exists)}
        {
            conduit:Set[${Entity[Name == "Origin Conduit (Triglavian)"]}]
            Logger:Info["Approaching origin conduit (exit)..."]
            This.StateManager:SetState["EXIT_ABYSS"]
            return
        }
        else
        {
            Logger:Warning["No conduit found!"]
            return
        }

        ; Approach conduit
        if ${conduit.Distance} > GATE_APPROACH_DISTANCE
        {
            conduit:Approach
            return
        }

        ; Activate conduit
        EVE:Execute[CmdStopShip]
        wait 10
        conduit:Activate

        ; Wait for room transition
        wait 100
        This.HasGrabbedLoot:Set[FALSE]
        This.StateManager:SetState["RUN_SITE"]
    }

    method State_ExitAbyss()
    {
        ; Find origin conduit
        if ${Entity[Name == "Origin Conduit (Triglavian)"](exists)}
        {
            variable entity conduit = ${Entity[Name == "Origin Conduit (Triglavian)"]}

            if ${conduit.Distance} > GATE_APPROACH_DISTANCE
            {
                conduit:Approach
                return
            }

            EVE:Execute[CmdStopShip]
            wait 10
            conduit:Activate

            Logger:Info["Exiting abyss..."]

            ; Wait for exit
            wait 200
            This.StatusChecked:Set[FALSE]
            This.StateManager:SetState["IDLE"]
        }
    }

    method State_ReturnHome()
    {
        if ${Me.InStation}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        if !${Me.InSpace}
        {
            return
        }

        Logger:Info["Returning to home station..."]

        ; Find home bookmark and dock
        variable index:bookmark bookmarks
        EVE:GetBookmarks[bookmarks]

        variable int i
        for (i:Set[1]; ${i} <= ${bookmarks.Used}; i:Inc)
        {
            if ${bookmarks.Get[${i}](exists)} && ${bookmarks.Get[${i}].Label.Equal[${This.Config.HomeBookmark}]}
            {
                if ${bookmarks.Get[${i}].JumpsTo} == 0
                {
                    bookmarks.Get[${i}].ToEntity:Dock
                    break
                }
            }
        }

        This.StateManager:SetState["DOCK"]
    }

    method State_Dock()
    {
        if ${Me.InStation}
        {
            Logger:Info["Docked successfully"]
            This.StateManager:SetState["UNLOAD_LOOT"]
            return
        }

        ; Wait for dock
        if ${This.StateManager.StateElapsedTime} > DOCK_WAIT_TIMEOUT
        {
            Logger:Warning["Dock timeout, retrying..."]
            This.StateManager:SetState["RETURN_HOME"]
        }
    }

    method State_UnloadLoot()
    {
        if !${Me.InStation}
        {
            This.StateManager:SetState["IDLE"]
            return
        }

        Logger:Info["Unloading loot..."]

        ; Ensure inventory is open
        if !${EVEWindow[Inventory](exists)}
        {
            EVE:Execute[OpenInventory]
            wait 20
            return
        }

        ; Get cargo items
        variable index:item cargoItems
        variable index:int64 itemsToMove

        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        ; Move non-essential items to hangar
        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)}
            {
                variable string itemName = ${cargoItems.Get[${i}].Name}

                ; Keep essential items
                if ${itemName.Equal[${This.Config.PrimaryAmmo}]} || \
                   ${itemName.Equal[${This.Config.SecondaryAmmo}]} || \
                   ${itemName.Equal[${This.Config.FilamentType}]} || \
                   ${itemName.Equal[${This.Config.MTUType}]} || \
                   ${itemName.Equal["Nanite Repair Paste"]} || \
                   ${itemName.Find["Script"]} > 0
                {
                    continue
                }

                itemsToMove:Insert[${cargoItems.Get[${i}].ID}]
            }
        }

        ; Move items
        if ${itemsToMove.Used} > 0
        {
            EVE:MoveItemsTo[itemsToMove, MyStationHangar, Hangar]
            wait 30
        }

        ; Stack hangar
        EVE:StackItems[MyStationHangar, Hangar]
        wait 20

        This.StateManager:SetState["REPAIR"]
    }

    method State_Error()
    {
        Logger:Critical["Error state reached. Stopping bot."]
        This:Stop
    }

    ; ========================================================================
    ; HELPER METHODS
    ; ========================================================================

    member:bool IsInAbyss()
    {
        if !${Me.InSpace}
        {
            return FALSE
        }

        ; Check for abyss indicators
        if ${Entity[Name == "Unstable Abyssal Depths" && Distance < 200000](exists)}
        {
            return TRUE
        }

        if ${Entity[Name == "Transfer Conduit (Triglavian)" && Distance < 100000](exists)} || \
           ${Entity[Name == "Origin Conduit (Triglavian)" && Distance < 100000](exists)}
        {
            return TRUE
        }

        return FALSE
    }

    member:bool HasEnemiesPresent()
    {
        if ${Entity[Group =- "${GROUP_ABYSSAL_SHIP}" && !IsMoribund && Name !~ "Vila Swarmer"](exists)}
        {
            return TRUE
        }

        if ${Entity[Group =- "${GROUP_ABYSSAL_DRONE}" && !IsMoribund && Name !~ "Vila Swarmer"](exists)}
        {
            return TRUE
        }

        return FALSE
    }

    member:bool IsLocalSafe()
    {
        variable index:pilot LocalPilots
        EVE:GetLocalPilots[LocalPilots]

        variable int i
        for (i:Set[1]; ${i} <= ${LocalPilots.Used}; i:Inc)
        {
            if ${LocalPilots.Get[${i}](exists)}
            {
                ; Skip self
                if ${LocalPilots.Get[${i}].CharID} == ${Me.CharID}
                {
                    continue
                }

                ; Check standings
                variable float standing = ${Me.GetStanding[${LocalPilots.Get[${i}].CharID}]}
                if ${standing} < 0
                {
                    return FALSE
                }
            }
        }

        return TRUE
    }

    member:bool HasSufficientAmmo()
    {
        if !${EVEWindow[Inventory](exists)}
        {
            return TRUE
        }

        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int ammoCount = 0
        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Name.Equal[${This.Config.PrimaryAmmo}]}
            {
                ammoCount:Inc[${cargoItems.Get[${i}].Quantity}]
            }
        }

        return ${ammoCount} >= ${Math.Calc[${This.Config.AmmoAmount} * 0.4]}
    }

    member:bool HasSufficientDrones()
    {
        if !${EVEWindow[Inventory](exists)}
        {
            return TRUE
        }

        if !${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay](exists)}
        {
            EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay]:MakeActive
            return FALSE
        }

        variable float capacity = ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay].Capacity}
        variable float used = ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay].UsedCapacity}
        variable float missing = ${Math.Calc[${capacity} - ${used}]}

        ; Acceptable missing drone space based on bay size
        if ${capacity} <= 25 && ${missing} > 10
        {
            return FALSE
        }
        elseif ${capacity} <= 50 && ${missing} > 20
        {
            return FALSE
        }
        elseif ${missing} > 30
        {
            return FALSE
        }

        return TRUE
    }

    member:bool HasFilament()
    {
        if !${EVEWindow[Inventory](exists)}
        {
            return TRUE
        }

        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Name.Equal[${This.Config.FilamentType}]}
            {
                return TRUE
            }
        }

        return FALSE
    }

    member:bool HasMTU()
    {
        if !${This.Config.UseMTU}
        {
            return TRUE
        }

        if !${EVEWindow[Inventory](exists)}
        {
            return TRUE
        }

        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Type.Equal[${This.Config.MTUType}]}
            {
                return TRUE
            }
        }

        return FALSE
    }

    member:bool HasDrugs()
    {
        if !${This.Config.UseDrugs}
        {
            return TRUE
        }

        ; Implementation would check for specific drugs in cargo
        return TRUE
    }

    member:bool HasNanitePaste()
    {
        if !${This.Config.UseOverheat}
        {
            return TRUE
        }

        if !${EVEWindow[Inventory](exists)}
        {
            return TRUE
        }

        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int pasteCount = 0
        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Name.Equal["Nanite Repair Paste"]}
            {
                pasteCount:Inc[${cargoItems.Get[${i}].Quantity}]
            }
        }

        return ${pasteCount} >= ${Math.Calc[${This.Config.NanitePasteAmount} * 0.4]}
    }

    member:bool IsMTUDeployed()
    {
        return ${Entity[Group =- "Mobile Tractor Unit"](exists)}
    }

    member:bool HasLootableWrecks()
    {
        return ${Entity[Name =- "Wreck" && !IsMoribund && !IsWreckEmpty && Distance < 50000](exists)}
    }

    ; ========================================================================
    ; COMBAT HELPER METHODS
    ; ========================================================================

    method ActivateDefensiveModules()
    {
        ; Activate prop mod
        if ${This.Config.PropModSlot} >= 0
        {
            if !${MyShip.Module[MedSlot${This.Config.PropModSlot}].IsActive}
            {
                MyShip.Module[MedSlot${This.Config.PropModSlot}]:Activate
            }
        }

        ; Activate hardeners
        if ${This.Config.Hardener1Slot} >= 0
        {
            if !${MyShip.Module[MedSlot${This.Config.Hardener1Slot}].IsActive}
            {
                MyShip.Module[MedSlot${This.Config.Hardener1Slot}]:Activate
            }
        }

        if ${This.Config.Hardener2Slot} >= 0
        {
            if !${MyShip.Module[MedSlot${This.Config.Hardener2Slot}].IsActive}
            {
                MyShip.Module[MedSlot${This.Config.Hardener2Slot}]:Activate
            }
        }
    }

    method ManageDrones()
    {
        variable index:activedrone activeDrones
        Me:GetActiveDrones[activeDrones]

        ; Launch drones if needed
        if ${activeDrones.Used} < 3 && ${MyShip.DronesInBay} > 0
        {
            MyShip:LaunchAllDrones
            wait 20
        }

        ; Engage targets
        if ${Me.TargetCount} > 0 && ${activeDrones.Used} > 0
        {
            variable bool anyIdle = FALSE
            variable int i
            for (i:Set[1]; ${i} <= ${activeDrones.Used}; i:Inc)
            {
                if ${activeDrones.Get[${i}](exists)} && ${activeDrones.Get[${i}].State} == 0
                {
                    anyIdle:Set[TRUE]
                    break
                }
            }

            if ${anyIdle}
            {
                EVE:Execute[CmdDronesEngage]
            }
        }
    }

    method ManageTargeting()
    {
        ; Get current target counts
        variable int currentTargets = ${Me.TargetCount}
        variable int maxTargets = ${Me.MaxLockedTargets}
        variable int lockingTargets = 0

        variable index:entity targeting
        Me:GetTargeting[targeting]
        lockingTargets:Set[${targeting.Used}]

        ; Lock new targets if we have room
        if ${Math.Calc[${currentTargets} + ${lockingTargets}]} < ${maxTargets}
        {
            variable index:entity enemies
            EVE:QueryEntities[enemies]

            variable int i
            for (i:Set[1]; ${i} <= ${enemies.Used}; i:Inc)
            {
                if ${enemies.Get[${i}](exists)}
                {
                    if ${enemies.Get[${i}].Group.Equal[${GROUP_ABYSSAL_SHIP}]} || ${enemies.Get[${i}].Group.Equal[${GROUP_ABYSSAL_DRONE}]}
                    {
                        if !${enemies.Get[${i}].Name.Equal["Vila Swarmer"]} && \
                           !${enemies.Get[${i}].IsLockedTarget} && \
                           !${enemies.Get[${i}].BeingTargeted} && \
                           ${enemies.Get[${i}].Distance} < ${This.Config.DroneRange}
                        {
                            enemies.Get[${i}]:LockTarget
                            Logger:Debug["Locking target: ${enemies.Get[${i}].Name}"]
                            break
                        }
                    }
                }
            }
        }
    }

    method ActivateWeapons()
    {
        ; Get current locked targets
        variable index:entity targets
        Me:GetTargets[targets]

        if ${targets.Used} == 0
        {
            return
        }

        ; Make first target active
        targets.Get[1]:MakeActiveTarget

        ; Activate weapons if target in range
        if ${targets.Get[1].Distance} <= ${This.Config.AmmoRange}
        {
            if !${MyShip.Module[HiSlot0].IsActive}
            {
                MyShip.Module[HiSlot0]:Activate
            }
        }
    }

    method NavigateDuringCombat()
    {
        ; Find cache to orbit
        if ${Entity[Name =- "Triglavian Bioadaptive Cache" || Name =- "Triglavian Biocombinative Cache"](exists)}
        {
            variable entity cache = ${Entity[Name =- "Triglavian Bioadaptive Cache" || Name =- "Triglavian Biocombinative Cache"]}

            if ${MyShip.ToEntity.Mode} != MOVE_ORBITING
            {
                cache:Orbit[${DEFAULT_ORBIT_DISTANCE}]
            }
        }
    }

    method ConsumeDrugsIfNeeded()
    {
        if !${This.Config.UseDrugs}
        {
            return
        }

        ; Check if we need drugs
        variable bool needDrugs = FALSE

        if ${MyShip.ShieldPct} < ${SHIELD_DRUG_THRESHOLD}
        {
            needDrugs:Set[TRUE]
        }

        if ${MyShip.ArmorPct} < ${ARMOR_DRUG_THRESHOLD}
        {
            needDrugs:Set[TRUE]
        }

        if !${needDrugs}
        {
            return
        }

        ; Try to consume drugs (with cooldown tracking)
        ; Hardshell drugs
        if ${LavishScript.RunningTime} >= ${This.HardshellCooldown}
        {
            This:TryConsumeDrug["Agency 'Hardshell'"]
        }

        ; Blue Pill
        if ${LavishScript.RunningTime} >= ${This.BluePillCooldown}
        {
            This:TryConsumeDrug["Blue Pill"]
        }

        ; Exile
        if ${LavishScript.RunningTime} >= ${This.ExileCooldown}
        {
            This:TryConsumeDrug["Exile"]
        }
    }

    method TryConsumeDrug(string drugNamePartial)
    {
        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Name.Find[${drugNamePartial}]} > 0
            {
                cargoItems.Get[${i}]:ConsumeBooster
                Logger:Info["Consumed ${cargoItems.Get[${i}].Name}"]

                ; Set cooldown (30 minutes)
                if ${drugNamePartial.Find["Hardshell"]} > 0
                {
                    This.HardshellCooldown:Set[${Math.Calc[${LavishScript.RunningTime} + 1800000]}]
                }
                elseif ${drugNamePartial.Find["Blue Pill"]} > 0
                {
                    This.BluePillCooldown:Set[${Math.Calc[${LavishScript.RunningTime} + 1800000]}]
                }
                elseif ${drugNamePartial.Find["Exile"]} > 0
                {
                    This.ExileCooldown:Set[${Math.Calc[${LavishScript.RunningTime} + 1800000]}]
                }

                return
            }
        }
    }

    method DeployMTUIfNeeded()
    {
        if ${This.IsMTUDeployed}
        {
            return
        }

        ; Deploy MTU from cargo
        variable index:item cargoItems
        EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipCargo]:GetItems[cargoItems]

        variable int i
        for (i:Set[1]; ${i} <= ${cargoItems.Used}; i:Inc)
        {
            if ${cargoItems.Get[${i}](exists)} && ${cargoItems.Get[${i}].Type.Equal[${This.Config.MTUType}]}
            {
                cargoItems.Get[${i}]:LaunchForSelf
                Logger:Info["Deployed MTU"]
                return
            }
        }
    }

    method RepairOverheatedModules()
    {
        if ${MyShip.Module[HiSlot0].Damage} > 0 && \
           !${MyShip.Module[HiSlot0].IsActive} && \
           !${MyShip.Module[HiSlot0].IsBeingRepaired}
        {
            MyShip.Module[HiSlot0]:Repair
            Logger:Debug["Repairing overheated module"]
        }
    }

    ; ========================================================================
    ; LOADING HELPER FUNCTIONS
    ; ========================================================================

    function LoadItem(string itemName, int quantity, string destination)
    {
        if !${EVEWindow[Inventory](exists)}
        {
            return
        }

        ; Get source items from hangar
        variable index:item hangarItems
        EVEWindow[Inventory].ChildWindow[${Me.Station.ID}, StationItems]:GetItems[hangarItems]

        variable int i
        for (i:Set[1]; ${i} <= ${hangarItems.Used}; i:Inc)
        {
            if ${hangarItems.Get[${i}](exists)} && ${hangarItems.Get[${i}].Name.Equal[${itemName}]}
            {
                if ${hangarItems.Get[${i}].Quantity} >= ${quantity}
                {
                    hangarItems.Get[${i}]:MoveTo[${MyShip.ID}, CargoHold, ${quantity}]
                    Logger:Debug["Loaded ${quantity}x ${itemName}"]
                    return
                }
                else
                {
                    hangarItems.Get[${i}]:MoveTo[${MyShip.ID}, CargoHold, ${hangarItems.Get[${i}].Quantity}]
                    Logger:Debug["Loaded ${hangarItems.Get[${i}].Quantity}x ${itemName} (partial)"]
                }
            }
        }
    }

    function LoadDrones()
    {
        if !${EVEWindow[Inventory](exists)}
        {
            return
        }

        ; Calculate drones needed
        if !${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay](exists)}
        {
            EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay]:MakeActive
            wait 20
            return
        }

        variable float capacity = ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay].Capacity}
        variable float used = ${EVEWindow[Inventory].ChildWindow[${Me.ShipID}, ShipDroneBay].UsedCapacity}
        variable float freeSpace = ${Math.Calc[${capacity} - ${used}]}

        if ${freeSpace} < 10
        {
            return
        }

        ; Load drones from hangar
        variable index:item hangarItems
        EVEWindow[Inventory].ChildWindow[${Me.Station.ID}, StationItems]:GetItems[hangarItems]

        variable int dronesNeeded = ${Math.Calc[${freeSpace} / 10].Int}

        variable int i
        for (i:Set[1]; ${i} <= ${hangarItems.Used}; i:Inc)
        {
            if ${hangarItems.Get[${i}](exists)} && ${hangarItems.Get[${i}].Name.Equal[${AbyssalMonkey.Config.DroneType}]}
            {
                variable int toLoad = ${Math.Min[${dronesNeeded}, ${hangarItems.Get[${i}].Quantity}]}
                hangarItems.Get[${i}]:MoveTo[${MyShip.ID}, DroneBay, ${toLoad}]
                Logger:Debug["Loaded ${toLoad}x ${AbyssalMonkey.Config.DroneType}"]
                dronesNeeded:Dec[${toLoad}]

                if ${dronesNeeded} <= 0
                {
                    break
                }
            }
        }
    }

    function ScoopMTU()
    {
        if !${Entity[Group =- "Mobile Tractor Unit"](exists)}
        {
            return
        }

        variable entity mtu = ${Entity[Group =- "Mobile Tractor Unit"]}

        ; Approach MTU
        if ${mtu.Distance} > LOOT_APPROACH_DISTANCE
        {
            mtu:Approach
            return
        }

        ; Loot MTU contents first
        mtu:Open
        wait 20
        EVEWindow[Inventory]:LootAll
        wait 20

        ; Scoop MTU
        mtu:ScoopToCargoHold
        This.HasGrabbedLoot:Set[TRUE]
        Logger:Info["Scooped MTU"]
    }

    ; ========================================================================
    ; PUBLIC CONTROL METHODS
    ; ========================================================================

    method Start()
    {
        if ${This.IsRunning}
        {
            Logger:Warning["Already running"]
            return
        }

        Logger:Info["Starting AbyssalMonkey..."]
        This.IsRunning:Set[TRUE]
        This.IsPaused:Set[FALSE]
        This.CurrentLoop:Set[0]
        This.StatusChecked:Set[FALSE]
        This.StatusGreen:Set[FALSE]
        This.StateManager:SetState["IDLE"]

        ; Disable entity cache for abyss stability
        ISXEVE:Debug_SetEntityCacheDisabled[TRUE]
    }

    method Stop()
    {
        Logger:Info["Stopping AbyssalMonkey..."]
        This.IsRunning:Set[FALSE]
        This.StateManager:Clear

        ISXEVE:Debug_SetEntityCacheDisabled[FALSE]
    }

    method Pause()
    {
        Logger:Info["Pausing AbyssalMonkey..."]
        This.IsPaused:Set[TRUE]
    }

    method Resume()
    {
        Logger:Info["Resuming AbyssalMonkey..."]
        This.IsPaused:Set[FALSE]
    }

    method Toggle()
    {
        if ${This.IsRunning}
        {
            This:Stop
        }
        else
        {
            This:Start
        }
    }
}

; ============================================================================
; GLOBAL INSTANCES
; ============================================================================

variable(global) obj_Logger Logger
variable(global) obj_AbyssalMonkey AbyssalMonkey

; ============================================================================
; MAIN ENTRY POINT
; ============================================================================

function main()
{
    ; Wait for ISXEVE
    while !${ISXEVE.IsReady}
    {
        echo "Waiting for ISXEVE..."
        wait 10
    }

    ; Wait for character and ship
    while !${Me(exists)} || !${MyShip(exists)}
    {
        echo "Waiting for character and ship..."
        wait 10
    }

    ; Initialize
    AbyssalMonkey:Initialize

    ; Main loop (event-driven, so just keep alive)
    while TRUE
    {
        wait 10
    }
}

function atexit()
{
    AbyssalMonkey:Shutdown
}
