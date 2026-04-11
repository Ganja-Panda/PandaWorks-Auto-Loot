PWAL Framework Overhaul Roadmap
Project Goal

PWAL is a clean architectural rebuild of the original Lazy Panda looting system for Starfield.

The goal is not to invent new behavior. The goal is to preserve the proven behavior of LZP while replacing the monolithic god-script structure with a modular, service-driven framework.

Core Design Principles
1. Preserve working behavior

LZP remains the behavioral source of truth for anything that already works reliably.

2. Replace bad structure

The old structure is being dismantled and redistributed into smaller, focused scripts with clear responsibilities.

3. CK remains the control plane

Creation Kit configuration continues to define:

effect identity
loot lists
behavior flags
settings globals
keywords
references
aliases
terminal-driven options

Papyrus does not invent configuration. It interprets CK-bound configuration and executes it through the framework.

4. Services own behavior

PWAL is built so that:

effects interpret CK configuration
scanners discover
processors route
validators decide
services perform focused work
5. No new god script

No single script should ever again own:

scanning
routing
validation
unlocking
destination logic
corpse logic
container logic
lifecycle logic

in one place.

Current Architectural Model
CK Layer

The CK defines what a looting effect is through:

ActivePerk
ActiveLootList
ActiveLootSpell
behavior booleans
settings globals
references
aliases
keywords
formlists

Each MGEF is a configured execution profile using shared Papyrus code.

Papyrus Framework Layer
LootEffectScript

Owns:

CK-bound effect interpretation
timer lifecycle
runtime setting cache
helper getters
scanner handoff
processor handoff

Does not own:

deep validation
unlocking
destination logic
container loops
corpse loops
LootScannerScript

Owns:

candidate discovery
form scan
keyword scan
multi-keyword scan
radius-based lookup
LootProcessorScript

Owns:

routing scanned refs into the correct path
container path
corpse path
activator path
spell path
loose item path
ContainerProcessorScript

Owns:

container-specific handling
take-all container behavior
filtered container transfer logic
container looted-state marking
unlock-service handoff
CorpseProcessorScript

Owns:

corpse-specific handling
take-all corpse behavior
filtered corpse transfer logic
corpse looted-state marking
corpse cleanup/removal
LootValidationScript

Owns:

may this target be touched
stealing rules
ownership and hostility rules
invalid target rejection
already-looted rejection if centralized there
DestinationResolverScript

Owns:

destination settings
category destination logic
runtime destination ref resolution
UnlockingServiceScript

Owns:

lock access logic
digipick/key/skill checks
container unlock attempts
Core / System Scripts

Own:

logging
runtime gating
install defaults
startup validation
version handling
Current Project Status
Completed or Mostly Established
Framework shape
modular looting architecture established
no new monolithic script structure
effect/service separation defined
Core scripts
LoggerScript
RuntimeManagerScript
System scripts
InstallManagerScript
StartupValidatorScript
VersionManagerScript
Looting scripts
LootEffectScript property contract established
LootScannerScript shell established
LootProcessorScript routing structure established
ContainerProcessorScript shell established
CorpseProcessorScript shell established
DestinationResolverScript established
LootValidationScript partial
UnlockingServiceScript partial
CK understanding
CK-bound effect properties are now fully recognized as the actual behavioral configuration layer
property groups and values from the old project are now properly understood
Work Still In Progress
1. Container filtered item loop

The actual working LZP filtered container logic still needs to be transplanted into ContainerProcessorScript.

2. Corpse filtered item loop

The actual working LZP filtered corpse logic still needs to be transplanted into CorpseProcessorScript.

3. Validation completion

LootValidationScript still needs to become the true authority for whether loot may be touched.

4. Unlocking completion

UnlockingServiceScript still needs the actual working lock logic transplanted from LZP.

5. Compile/runtime sanity

The new framework scripts need full compile and runtime verification once the looting pipeline is complete.

Quarantined / Unresolved Area
Ship-space looting

Ship-space looting is currently unresolved.

The old project contained experimental and patchwork attempts to make space looting work, but that logic is not trusted as final.

Current rule:

keep ship-related properties needed by CK
allow ship-container mode to exist in the framework
do not treat old ship hacks as final behavior
do not let unresolved space looting contaminate the main pipeline

Ship looting will be handled as a separate focused pass once the main framework is stable.

Immediate Development Priorities
Phase 1 — Finish Core Loot Pipeline
Priority 1

Complete ContainerProcessorScript

transplant working filtered container loop from LZP
preserve behavior
improve structure
avoid inventing replacement logic
Priority 2

Complete CorpseProcessorScript

transplant working filtered corpse loop from LZP
preserve behavior
improve structure
support corpse looted-state tracking and cleanup
Priority 3

Complete LootValidationScript

centralize actual "can take loot" logic
ownership
hostility
stealing
invalid targets
already looted
restrictions
Priority 4

Complete UnlockingServiceScript

transplant lock access logic
support digipicks, keys, and skill checks
only operate through ContainerProcessorScript
Phase 2 — Integration and Stability

After the core loot pipeline is complete:

compile all looting scripts
verify script signatures match
verify timer lifecycle cleanup
verify scanner → processor → service chain
verify looted keywords apply correctly
verify settings cache values behave correctly
verify destination resolution during real transfers
verify corpse removal behavior
Phase 3 — Ship Looting Investigation

After the main framework is stable:

isolate real ship-looting requirements
investigate working implementation
obtain permission for external snippet reuse if needed
reimplement cleanly in PWAL style
integrate without contaminating the main ground/ship-interior pipeline
Phase 4 — Final Framework Polish
clean up remaining placeholder logic
update documentation
update README/license/release notes
verify install defaults
verify terminal behavior
verify update/version flow
prepare release build
Rules For All Future Work
1. Do not invent replacement logic where LZP already contains working logic

If it works in LZP, transplant it.

2. Improve structure, not behavior, unless a behavior change is intentional

PWAL is an overhaul of architecture, not a random redesign of how the mod behaves.

3. Always ask what CK is already telling the script

Do not replace CK-driven behavior with guessed runtime logic.

4. Keep responsibilities narrow

No script should absorb unrelated work just because it is convenient.

5. Unresolved behavior gets quarantined, not blended into the framework

Especially ship-space looting.

Current Working Direction

The project is now past the “what is PWAL supposed to be?” stage.

The direction is clear:

CK-configured effect profiles
modular runtime services
preserved working behavior
improved architecture
no god script
no patchwork fallback junk
no fake replacement logic

PWAL is now being built as the same functional looting system, rebuilt into the framework it should have been from the start.