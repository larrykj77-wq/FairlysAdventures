param([switch]$NoPublish)
$ErrorActionPreference = 'Stop'
$env:bB = Join-Path $PSScriptRoot 'tools\bb\bB'
$env:PATH = "$env:bB;$env:PATH"
$runtime = Join-Path $PSScriptRoot 'tools\wasmtime\wasmtime-v50.0.0-x86_64-windows\wasmtime.exe'
Push-Location $PSScriptRoot
try {
    & ./build-dragon-link.ps1
    & cmd.exe /d /c 'preprocess < dungeon.bas | 2600basic.exe -i "%bB%" > bB.asm'
    if ($LASTEXITCODE -ne 0) { throw 'BASIC compilation failed' }
    & cmd.exe /d /c 'postprocess -i "%bB%" > dungeon.bas.asm'
    if ($LASTEXITCODE -ne 0) { throw 'Postprocessing failed' }
    & ./prepare-main.ps1
    & $runtime run --dir . tools/bb19/bB/dasm.wasm dungeon.bas.asm '-Itools/bb/bB/includes' '-f3' '-ldungeon.lst' '-sdungeon.sym' '-odungeon-main.tmp'
    if ($LASTEXITCODE -ne 0) { throw 'Main assembly failed' }
    & $runtime run --dir . tools/bb19/bB/dasm.wasm dragon-handoff.asm '-Itools/bb/bB/includes' '-f3' '-sdragon-handoff.sym' '-odragon-handoff.bin'
    if ($LASTEXITCODE -ne 0) { throw 'Handoff assembly failed' }
    & ./pack-main-dragon.ps1
    if (-not $NoPublish) { & ./publish-version.ps1 }
} finally { Pop-Location }
