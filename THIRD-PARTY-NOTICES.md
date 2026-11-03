# Third-party notices

The project uses batari Basic support assembly. Its distributed licensing
overview says the compiler source is GPL v2, while included and generated
6507 assembly is CC0 and generated game binaries may be separately licensed.
The original overview and full texts are retained in
Source/THIRD-PARTY-LICENSES/batari-Basic-LICENSE.txt.

Files with CC0 notices, including banksw.asm, custom_arena.asm,
score_graphics.asm, startup.asm, status-font.asm and std_overscan.asm,
retain those terms. Batari Basic-derived portions of local kernel wrappers
also retain their original CC0 status. The game's noncommercial license
cannot restrict those portions independently. Source notices remain intact.

Upstream: https://github.com/batari-Basic/batari-Basic
CC0: https://creativecommons.org/publicdomain/zero/1.0/

Compiler binaries, the compiler's C source, DASM and Wasmtime are not bundled.
Source/setup-tools.ps1 downloads their official packages for building.
Their respective licenses apply to those external tools. Using a compiler
does not change the stated license of this game's original code.
