param([string]$BaseName='dragon-base.tmp',[string]$SymbolsName='dragon.sym',[string]$OutputName='dragon.bin')
# Build a standard 16 KB F6 cartridge. Banks 1 and 3 share the display code;
# their art differs, so the complete reward room needs no extra console RAM.
$ErrorActionPreference = 'Stop'
$base = [IO.File]::ReadAllBytes((Join-Path $PSScriptRoot $BaseName))
if ($base.Length -ne 8192) { throw 'Expected an 8 KB assembly intermediate' }
$symbols = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $PSScriptRoot $SymbolsName))) {
    if ($line -match '^([\w.]+)\s+([0-9a-fA-F]{4})\s') { $symbols[$matches[1]] = [Convert]::ToInt32($matches[2],16) }
}
$combat = [byte[]]::new(4096)
[Array]::Copy($base,4096,$combat,0,4096)
if ($SymbolsName -eq 'integrated.sym') {
    # Keep the left escape door visible during every breath direction.
    # Quiet uses VictoryLeft1; the shared RightWall remains closed.
    foreach ($name in @('UpperLeft1','MiddleLeft1','LowerLeft1')) {
        for ($y=20; $y -lt 36; $y++) {
            $index = ($symbols[$name] -band 4095) + $y
            $combat[$index] = $combat[$index] -band 0x3F
        }
    }
}
$reward = [byte[]]$combat.Clone()
function Set-RewardRows([string]$name, [byte[]]$rows) {
    if ($rows.Length -ne 88) { throw "Invalid row count: $name" }
    [Array]::Copy($rows,0,$reward,($symbols[$name] -band 4095),88)
}
[byte[]]$closed = 0x7E,0xFF,0x81,0xBD,0xA5,0x81,0xFF,0x7E
[byte[]]$opened = 0x7E,0x42,0x42,0x3C,0xFF,0x81,0xFF,0x7E
$poseNames = @('DragonIdle','DragonUpper','DragonLower','DragonBoth')
for ($flags=0; $flags -lt 4; $flags++) {
    $rows = [byte[]]::new(88)
    $upper = if ($flags -band 1) { $opened } else { $closed }
    $lower = if ($flags -band 2) { $opened } else { $closed }
    [Array]::Copy($upper,0,$rows,30,8)
    [Array]::Copy($lower,0,$rows,54,8)
    Set-RewardRows $poseNames[$flags] $rows
}
$closedDoor = [byte[]]::new(88)
for ($y=0; $y -lt 88; $y++) {
    $closedDoor[$y] = $combat[($symbols['QuietRight1'] -band 4095)+$y]
}
for ($y=39; $y -lt 49; $y++) { $closedDoor[$y] = 0x80 }
$closedDoor[43] = 0xC0
$openDoor = [byte[]]$closedDoor.Clone()
for ($y=38; $y -lt 50; $y++) { $openDoor[$y] = 0 }
Set-RewardRows 'DragonIdleR' $closedDoor
Set-RewardRows 'RewardDoorOpen' $openDoor
$gate = [byte[]]::new(88)
[byte[]]$two = 0x3C,0x66,0x06,0x0C,0x18,0x30,0x60,0x7E
if ($SymbolsName -eq 'integrated.sym') {
    # The integrated gate only pauses at the final (fifth) level.
    $two = [byte[]](0x7E,0x60,0x60,0x7C,0x06,0x06,0x66,0x3C)
}
[Array]::Copy($two,0,$gate,36,8)
Set-RewardRows 'RewardGate' $gate
$rom = [byte[]]::new(16384)
# The unused bank also has a safe reset vector.
[Array]::Copy($combat,0,$rom,0,4096)
[Array]::Copy($reward,0,$rom,4096,4096)
[Array]::Copy($base,0,$rom,8192,4096)
[Array]::Copy($combat,0,$rom,12288,4096)
[IO.File]::WriteAllBytes((Join-Path $PSScriptRoot $OutputName),$rom)
Write-Host "Built $OutputName (16384 bytes, F6, standard 128-byte console RAM)"
