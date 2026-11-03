# Downloads official portable tools into this project; no system installation.
$ErrorActionPreference='Stop'
$packages=@(
 @('https://github.com/batari-Basic/batari-Basic/releases/download/v1.8/bB-1.8-win-x64.zip','bb'),
 @('https://github.com/batari-Basic/batari-Basic/releases/download/v1.9/bB-1.9-wasm.zip','bb19'),
 @('https://github.com/bytecodealliance/wasmtime/releases/download/v50.0.0/wasmtime-v50.0.0-x86_64-windows.zip','wasmtime')
)
New-Item -ItemType Directory -Force "$PSScriptRoot\tools" | Out-Null
foreach($package in $packages) {
 $zip=Join-Path $PSScriptRoot "tools\$($package[1]).zip"
 Invoke-WebRequest $package[0] -OutFile $zip
 Expand-Archive $zip (Join-Path $PSScriptRoot "tools\$($package[1])") -Force
}
Write-Host 'Tools ready. Run .\build.ps1'
