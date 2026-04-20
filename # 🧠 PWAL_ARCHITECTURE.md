# 🧠 PWAL_ARCHITECTURE.md

## Overview

**PandaWorks Auto Loot (PWAL)** is a **data-driven, MagicEffect-based loot framework** for Bethesda games (currently Starfield).

It is a **runtime execution system** where:

- CK (Creation Kit) defines behavior
- Papyrus executes that behavior
- MagicEffects act as independent workers
- FormLists define discovery and filtering rules
- Globals define runtime configuration
- Timers drive execution

---

## Core Execution Model

Perk → Spell → MagicEffect → Timer → Scanner → Validator → Processor → Destination

---

## Perk / Spell Role

### Perk
- Feature toggle / injector
- Grants spells
- Does not execute logic

### Spell
- Applies MagicEffects
- Distributes behavior into runtime

---

## MagicEffect Model (CRITICAL)

Each MagicEffect:

- Is an independent execution unit
- Has its own configuration
- Has its own Timer ID
- Runs its own loop
- Does NOT coordinate with other effects

---

## Execution Model (CRITICAL)

Each MagicEffect:

- Starts its own timer using `StartTimer()`
- Executes independently
- Has no central controller

The system is **distributed across parallel effect instances**.

There is NO single master loop.

---

## Timer Model

- Each effect uses a unique Timer ID
- No global update loop exists
- `RegisterForUpdate()` is not used

---

## Data-Driven Design

### CK Defines Behavior

Behavior is defined through:

- FormLists
- Globals
- Conditions
- MagicEffect properties

Scripts DO NOT infer behavior globally.

---

## MagicEffect Configuration (CRITICAL)

Behavior is controlled per MagicEffect using properties:

- `ActiveLootList`
- `bIsContainer`
- `bIsDeadActor`
- `bIsActivator`
- `bIsActivatedBySpell`
- `bIsKeyword`
- `bIsMultipleKeyword`

Scripts do NOT determine behavior.

CK configuration determines behavior.

---

## FormList Roles (CRITICAL)

FormLists are NOT uniform data containers.

They are used as:

- Keyword sets
- Type descriptors
- Category definitions
- Container classifiers
- Direct scan descriptors (FormList-as-Form)

### Important

FormLists are **context-dependent** and their meaning is defined by the MagicEffect.

---

## ActiveLootList

- Assigned per MagicEffect
- Defines the scan/discovery contract
- Determines what the effect searches for

---

## System Loot Registry

PWAL_FLST_System_Looting_Lists  
PWAL_FLST_System_Looting_Globals  

- Ordered lists
- Paired by index

Example:

```papyrus
for i:
    if Globals[i] enabled:
        process Lists[i]  

Used for:
- category filtering
- transfer rules

---

## Container FormLists

PWAL_FLST_Container_*

- Represent approved base container types
- NOT individual containers
- Used for classification

---

## Domain Separation (NON-NEGOTIABLE)

Each domain is handled separately:

### Containers
- Inventory-based
- Bulk transfer logic

### Corpses
- Actor-based
- Requires preprocessing:
  - race checks
  - unequip
  - body handling

### Loose Objects
- Direct world references

### Harvest
- Flora / non-lethal system
- Separate execution path

### Space (Future)
- Ship debris
- Asteroids
- Space containers

---

## IMPORTANT

Containers and Corpses are NOT the same.

They are intentionally processed differently.

---

## Scan Modes (CRITICAL)

Scanning behavior is defined per MagicEffect:

- Keyword-based scanning
- Multi-keyword scanning
- Type-based scanning (FormList-as-Form)

Scan mode is controlled by effect flags.

There is NO single universal scan logic.

---

## Scanner Model

Uses:

- `FindAllReferencesWithKeyword`
- `FindAllReferencesOfType`

Driven by ActiveLootList.

---

## Validation Layer

Ensures:

- reference exists
- reference is valid
- reference is allowed
- ownership rules are respected

Includes:

- `IsBoundGameObjectAvailable()`
- `IsDeleted()`
- `IsDisabled()`
- `IsDestroyed()`

---

## Processor Layer

LootProcessor routes to:

- ContainerProcessor
- CorpseProcessor
- Activator
- Spell Activation
- Loose Loot

---

## Destination Model (CRITICAL)

PWAL uses persistent, always-available storage:

- Player
- Ship cargo
- Lodge
- Internal containers

### Guarantees

- Always loaded
- Always accessible
- No item loss risk

---

## Filtering Behavior

Uses:

- System_Looting_Lists
- System_Looting_Globals

Applied during:

- container processing
- corpse processing

---

## Engine Alignment

PWAL follows Starfield design:

- Timer-based execution
- Scan-based discovery
- CK-driven behavior
- FormList/Keyword usage
- Validation for unstable references

---

## Non-Negotiables

- MagicEffects are execution units
- Each effect runs independently
- FormLists define behavior
- FormList-as-Form scanning is intentional
- Containers ≠ Corpses
- System is scan-driven
- CK is the source of truth
- Destinations are persistent

---

## What PWAL Is

A modular, data-driven execution framework.

---

## What PWAL Is NOT

- Not a single loop
- Not event-driven
- Not container-only
- Not hardcoded logic

---

## END