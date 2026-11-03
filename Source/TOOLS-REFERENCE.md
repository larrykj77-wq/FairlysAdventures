# Build tools reference

The release includes game source and build scripts, without compiler binaries.

## Tools used

- batari Basic 1.8, Windows x64: compiles dungeon.bas.
  https://github.com/batari-Basic/batari-Basic/releases/tag/v1.8
- batari Basic 1.9 WebAssembly distribution: supplies dasm.wasm, used to
  assemble the custom 6502 assembly and generated main program.
  https://github.com/batari-Basic/batari-Basic/releases/tag/v1.9
- Wasmtime 50.0.0, Windows x64: runs the WebAssembly assembler.
  https://github.com/bytecodealliance/wasmtime/releases/tag/v50.0.0
- Windows PowerShell and Windows command shell: run the build scripts.
- Visual Studio Code with Atari Dev Studio: editing environment used during
  development; not required by the command-line build.
  https://marketplace.visualstudio.com/items?itemName=chunkypixel.atari-dev-studio
- Stella: Atari 2600 emulator used for playtesting. ROM checks also used the
  installed Stella 2023 libretro core. Emulators are not needed to compile.
  https://stella-emu.github.io/

Source/setup-tools.ps1 contains the exact download URLs and folder structure
expected by the Windows build. Run that script before building, or install the
same portable packages into the expected Source/tools directories manually.
Third-party tools remain subject to their respective licenses.
