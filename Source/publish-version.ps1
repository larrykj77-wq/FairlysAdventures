param([string]$Directory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
$source = Join-Path $Directory 'dungeon.bin'
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw 'Build dungeon.bin before publishing a version.' }
$latestFile = Join-Path $Directory 'latest-rom.txt'
$names = @(Get-ChildItem -LiteralPath $Directory -File -Filter '*V*.bin' | Select-Object -ExpandProperty Name)
if (Test-Path -LiteralPath $latestFile) { $names += (Get-Content -LiteralPath $latestFile -Raw).Trim() }
$highest = 0
foreach ($name in $names) {
    if ($name -match '^(?:dungeon)?V(?<major>\d*)\.(?<minor>\d{2})\.bin$') {
        $major = 0
        if ($Matches.major) { $major = [int]$Matches.major }
        $highest = [Math]::Max($highest, $major * 100 + [int]$Matches.minor)
    }
}
$next = $highest + 1
$major = [int][Math]::Floor($next / 100)
$prefix = 'dungeonV'
if ($major -gt 0) { $prefix += $major.ToString() }
$filename = '{0}.{1:D2}.bin' -f $prefix, ([int]($next % 100))
[IO.File]::Copy($source, (Join-Path $Directory $filename), $false)
[IO.File]::WriteAllText($latestFile, $filename + [Environment]::NewLine)
Write-Host "Saved $filename (latest main game; older versions kept)"

