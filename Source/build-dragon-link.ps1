$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$runtime = Join-Path $root 'tools\wasmtime\wasmtime-v50.0.0-x86_64-windows\wasmtime.exe'
$headers = Join-Path $root 'tools\bb\bB\includes'
Push-Location (Join-Path $root 'dragon-room')
try {
    & $runtime run --dir . --dir $headers (Join-Path $root 'tools\bb19\bB\dasm.wasm') dragon.asm "-I$headers" '-DINTEGRATED=1' '-f3' '-lintegrated.lst' '-sintegrated.sym' '-ointegrated-base.tmp'
    if ($LASTEXITCODE -ne 0) { throw 'Integrated dragon assembly failed' }
    & ./pack-rewards.ps1 -BaseName integrated-base.tmp -SymbolsName integrated.sym -OutputName integrated.bin
} finally { Pop-Location }
$symbols=@{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root 'dragon-room\integrated.sym'))) {
    if ($line -match '^([\w.]+)\s+([0-9a-fA-F]{4})\s') { $symbols[$matches[1]]=[Convert]::ToInt32($matches[2],16) }
}
$equates=@()
$equates+=('DragonLogicStartRoom = $'+$symbols['LogicStartRoom'].ToString('X4'))
$equates+=('DragonDisplayFrame = $'+$symbols['DisplayFrame'].ToString('X4'))
$equates+=('DragonDisplaySyncLines = $'+$symbols['DisplaySyncLines'].ToString('X4'))
foreach ($name in @('hp','lives','wandTier','grace','held','tick')) { $equates+=('D_'+$name+' = $'+$symbols[$name].ToString('X4')) }
[IO.File]::WriteAllLines((Join-Path $root 'dragon-link.inc'),$equates)
