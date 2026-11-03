$ErrorActionPreference = 'Stop'
$root=$PSScriptRoot
$main=[IO.File]::ReadAllBytes((Join-Path $root 'dungeon-main.tmp'))
$dragon=[IO.File]::ReadAllBytes((Join-Path $root 'dragon-room\integrated.bin'))
$helper=[IO.File]::ReadAllBytes((Join-Path $root 'dragon-handoff.bin'))
if ($main.Length -ne 16384 -or $dragon.Length -ne 16384 -or $helper.Length -ne 4096) { throw 'Unexpected integration image sizes' }
$map=@{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root 'dungeon.sym'))) {
    if ($line -match '^([\w.]+)\s+([0-9a-fA-F]{4})\s') { $map[$matches[1]]=[Convert]::ToInt32($matches[2],16) }
}
foreach ($item in @(@('MainResetBridge',0xFB4),@('MainDragonBridge',0xFBA),@('MainResumeBridge',0xFC0),@('DragonInitBridge',0xFC6),@('DragonFrameBridge',0xFD0),@('InterfaceBridge',0xFD6),@('DragonAlignedFrameBridge',0xFE0))) {
    if (($map[$item[0]] -band 4095) -ne $item[1]) { throw "Bridge moved: $($item[0])" }
}
[Array]::Copy($helper,0,$dragon,0,4096)
for ($bank=1; $bank -lt 4; $bank++) {
    for ($offset=0xF00; $offset -lt 0xF40; $offset++) {
        $pos=$bank*4096+$offset
        if ($dragon[$pos] -eq 0x2C -and $dragon[$pos+2] -eq 0x1F -and $dragon[$pos+1] -ge 0xF7 -and $dragon[$pos+1] -le 0xF9) { $dragon[$pos+1]+=2 }
    }
}
# The common bank bridges are identical in all eight banks.
for ($bank=0; $bank -lt 4; $bank++) { [Array]::Copy($main,0x3FB4,$dragon,$bank*4096+0xFB4,64) }
$rom=[byte[]]::new(32768)
[Array]::Copy($main,0,$rom,0,16384)
[Array]::Copy($dragon,0,$rom,16384,16384)
# Boot reliably into the title regardless of the cartridge's initial bank.
for ($bank=0; $bank -lt 8; $bank++) {
    $rom[$bank*4096+0xFFC]=0xB4; $rom[$bank*4096+0xFFD]=0xFF
    $rom[$bank*4096+0xFFE]=0xB4; $rom[$bank*4096+0xFFF]=0xFF
}
[IO.File]::WriteAllBytes((Join-Path $root 'dungeon.bin'),$rom)
Write-Host 'Built dungeon.bin (32768 bytes, F4; main game + integrated dragon; no extra RAM)'
