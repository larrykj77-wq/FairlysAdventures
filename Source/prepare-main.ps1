$ErrorActionPreference = 'Stop'
$path = Join-Path $PSScriptRoot 'dungeon.bas.asm'
$source = [IO.File]::ReadAllText($path)
# bB emits its standard routines in the nominal last bank. Keep the main
# program in banks 0..3; the approved dragon owns the other four F4 banks.
$first = $source.IndexOf(' if ECHO4')
$last = $source.IndexOf('; Project display entry.', $first)
if ($first -lt 0 -or $last -lt 0) { throw 'Cannot locate generated main-bank layout' }
$source = $source.Substring(0,$first) + $source.Substring($last)
$source = [regex]::Replace($source,'(?im)ldx #8(\s*\r?\n\s*jmp BS_jsr)','ldx #4$1')
$source = [regex]::Replace($source,'(?m)^(\s*ORG \$)8([0-9A-Fa-f]{3})','${1}4$2')
$source = [regex]::Replace($source,'(?m)^(\s*RORG \$)F([0-9A-Fa-f]{3})','${1}7$2')
[IO.File]::WriteAllText($path,$source)
