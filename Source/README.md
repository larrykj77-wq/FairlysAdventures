# Fairly's Adventures - Atari 2600 source

Designed and playtested by Larry Johnson, with AI-assisted development.
This is the source for the V1.0 NTSC Atari 2600 game (32 KB F4, 128-byte RAM).
It matches the approved V.39 gameplay; development shortcuts are removed.

## Use and sharing

You may play, modify and share the covered game code and modified versions
for free. Credit Larry Johnson, retain notices and clearly identify changes.
Sales, paid cartridges and paid bundles are prohibited for covered material.
Read ../LICENSE and ../THIRD-PARTY-NOTICES.md for the complete terms and CC0
exceptions. This is source-available software with a noncommercial license.

## Build on Windows

From this Source folder, in Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup-tools.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .uild.ps1 -NoPublish
```

Setup downloads the external compilers/runtime into tools/; internet access
is required. The build produces dungeon.bin. It should match the published
Fairlys-Adventure-V1.0.bin. The included game code was previously rebuilt
byte for byte against that release. See TOOLS-REFERENCE.md for versions.

## Main files

- dungeon.bas: movement, enemies, rooms, shops and ordinary treasure.
- enemy-combat.asm and combat-feedback.asm: enemy hits and damage.
- custom_arena.asm, hud.asm and related fonts: room and HUD rendering.
- dragon-room/dragon.asm: dragon encounters, attacks, rewards and progression.
- title-screen.asm and ending-screen.asm: title and victory scenes.
- build.ps1 and supporting scripts: compile and combine cartridge banks.

The code uses only the current room; it does not retain cleared-room history.
Compiler tools, generated build outputs and development history are excluded.
