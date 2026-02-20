# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Heroes Dungeon (英雄地牢)** - A turn-based tactical roguelike RPG with isometric view, built with LÖVE 2D engine. Features a 4-person party dungeon exploration system.

## Running the Game

```bash
cd /home/lmz/projects/lua-roguelike-rpg
love .
```

Requirements: LÖVE 2D 11.0+ (includes Lua)

## Architecture

The game follows a modular architecture in `src/` directory:

- **core/** - Engine core, state machine, event system
- **render/** - Isometric rendering, camera, visual effects
- **ui/** - UI manager, panels, buttons, menus
- **battle/** - Turn-based combat, QTE system, AI opponents
- **entity/** - Entity base class, characters, heroes, enemies
- **dungeon/** - Floor generation, room layout, procedural map generation
- **character/** - Party system (4 members), attribute management
- **skill/** - Passive, active, and ultimate skills
- **equipment/** - Weapon trees, upgrades, affixes
- **quest/** - Objectives, puzzles, escape mechanics
- **data/** - Game data configs (heroes, enemies, items)
- **save/** - Save/load system, unlock progress
- **audio/** - Background music and sound effects
- **input/** - Input handling and hotkeys
- **util/** - Utility functions

Entry point: `main.lua` → initializes game state machine (start/playing/gameover)

## Key Game Features

- **Combat**: Turn-based tactical + QTE (parry/dodge mechanics)
- **Perspective**: Isometric 2D
- **Party**: Start with 1 hero, recruit up to 4 party members
- **Attributes**: STR (HP/physical), AGI (attack speed/dodge/crit), INT (magic/MP)
- **Skills**: Innate (passive/active) + scroll-learned
- **Equipment**: Weapon trees with fixed affixes, upgrade system
- **Dungeon**: Procedurally generated floors, room types (combat/elite/treasure/shop/altar/event/stairs)
- **Progression**: Unlock system (new heroes, equipment, skills via achievements)

## Current Development State

Early phase - only basic framework exists:
- `main.lua` - Minimal state machine skeleton with start screen
- `conf.lua` - LÖVE 2D window configuration (800x600, non-resizable)

The `src/` directory structure is planned but not yet implemented.

## Documentation

- `docs/SPEC.md` - Detailed requirements specification
- `docs/PROJECT_STRUCTURE.md` - Planned module breakdown

## Notes

- Primary documentation language: Chinese
- Development phases: Core Framework → Battle System → Growth System → Dungeon Content → Polish
