<#
.SYNOPSIS
  Dabara installer for Windows. Installs the prebuilt dabara.exe into %USERPROFILE%\.dabara\bin.

.DESCRIPTION
  No administrator rights, no compiler, no source. The download is checked against its published
  SHA-256 before anything is installed, and the install directory is added to YOUR user PATH only.

  One line (newest release, pre-releases included):
      irm https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.ps1 | iex

  With options (a piped script cannot take parameters, so wrap it):
      & ([scriptblock]::Create((irm https://raw.githubusercontent.com/feyroozecode/dabara_build/main/install.ps1))) -Version v0.6.0-beta.1

.PARAMETER Version     Release tag to install (default: the newest).
.PARAMETER InstallDir  Where to put dabara.exe (default: %USERPROFILE%\.dabara\bin).
.PARAMETER DryRun      Say what would happen, change nothing.
.PARAMETER Uninstall   Remove dabara.exe and the PATH entry this installer added.
.PARAMETER NoPath      Do not touch the PATH.
#>
[CmdletBinding()]
param(
  [string]$Version = $(if ($env:DABARA_VERSION) { $env:DABARA_VERSION } else { 'latest' }),
  [string]$InstallDir = $(if ($env:DABARA_INSTALL_DIR) { $env:DABARA_INSTALL_DIR } else { Join-Path $env:USERPROFILE '.dabara\bin' }),
  [switch]$DryRun,
  [switch]$Uninstall,
  [switch]$NoPath,
  # advanced / testing
  [string]$Repo = $(if ($env:DABARA_REPO) { $env:DABARA_REPO } else { 'feyroozecode/dabara_build' }),
  [string]$BaseUrl = $env:DABARA_BASE_URL,
  [string]$ApiUrl = $env:DABARA_API_URL,
  [string]$Target = $env:DABARA_TARGET
)

$ErrorActionPreference = 'Stop'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }

function Fail([string]$Message) { throw "dabara-install: error: $Message" }

if (-not $BaseUrl) { $BaseUrl = "https://github.com/$Repo/releases/download" }   # <BaseUrl>/<tag>/<asset>
if (-not $ApiUrl)  { $ApiUrl  = "https://api.github.com/repos/$Repo/releases" }

function Get-UserPath { [Environment]::GetEnvironmentVariable('Path', 'User') }

function Test-OnUserPath([string]$Dir) {
  $entries = (Get-UserPath) -split ';' | Where-Object { $_ -ne '' }
  return [bool]($entries | Where-Object { $_.TrimEnd('\') -ieq $Dir.TrimEnd('\') })
}

if ($Uninstall) {
  $exe = Join-Path $InstallDir 'dabara.exe'
  if (-not (Test-Path $exe)) { Write-Host "Nothing to remove: $exe does not exist."; return }
  if ($DryRun) { Write-Host "[dry run] would remove $exe"; return }
  Remove-Item -Force $exe
  if (-not (Get-ChildItem -Force $InstallDir -ErrorAction SilentlyContinue)) { Remove-Item -Force $InstallDir -ErrorAction SilentlyContinue }
  if (Test-OnUserPath $InstallDir) {
    $kept = (Get-UserPath) -split ';' | Where-Object { $_ -ne '' -and $_.TrimEnd('\') -ine $InstallDir.TrimEnd('\') }
    [Environment]::SetEnvironmentVariable('Path', ($kept -join ';'), 'User')
  }
  Write-Host "Removed $exe."
  return
}

# --- which build? ---------------------------------------------------------------------------------
if (-not $Target) {
  $arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
  switch ($arch) {
    'AMD64' { $Target = 'x86_64-pc-windows-msvc' }
    # Windows on ARM runs x64 programs through emulation until a native build is published.
    'ARM64' { $Target = 'x86_64-pc-windows-msvc' }
    default { Fail "unsupported CPU '$arch' (supported: x64, ARM64 via emulation)" }
  }
}

if ($Version -eq 'latest') {
  try { $releases = @(Invoke-RestMethod -UseBasicParsing -Uri "${ApiUrl}?per_page=1") } catch { $releases = @() }
  if ($releases.Count -eq 0 -or -not $releases[0].tag_name) {
    Fail "no Dabara release is published yet, so there is nothing to install. Check https://github.com/$Repo/releases (or pass -Version <tag> once one exists)."
  }
  $Tag = [string]$releases[0].tag_name
} elseif ($Version.StartsWith('v')) { $Tag = $Version } else { $Tag = "v$Version" }

$Asset = "dabara-$Tag-$Target.zip"
$Url = "$BaseUrl/$Tag/$Asset"
$Dest = Join-Path $InstallDir 'dabara.exe'

Write-Host "Dabara $Tag for $Target"
Write-Host "  from  $Url"
Write-Host "  to    $Dest"
if ($DryRun) { Write-Host '[dry run] nothing downloaded or installed.'; return }

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("dabara-install-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
  $zip = Join-Path $tmp $Asset
  try { Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $zip } catch { Fail "could not download $Url (is $Tag published for $Target?)" }
  try { Invoke-WebRequest -UseBasicParsing -Uri "$Url.sha256" -OutFile "$zip.sha256" } catch { Fail "could not download the checksum $Url.sha256 - refusing to install an unverified file" }

  $expected = ((Get-Content -Raw "$zip.sha256").Trim() -split '\s+')[0].ToLowerInvariant()
  if (-not $expected) { Fail 'the checksum file is empty' }
  $actual = (Get-FileHash -Algorithm SHA256 $zip).Hash.ToLowerInvariant()
  if ($expected -ne $actual) {
    Fail "checksum mismatch - the download is corrupt or has been tampered with (expected $expected, got $actual). Nothing was installed."
  }
  Write-Host "  checksum ok ($actual)"

  $out = Join-Path $tmp 'x'
  Expand-Archive -Path $zip -DestinationPath $out -Force
  $exe = Get-ChildItem -Path $out -Recurse -Filter 'dabara.exe' | Select-Object -First 1
  if (-not $exe) { Fail "the archive does not contain a 'dabara.exe' program" }

  New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
  $staged = Join-Path $InstallDir '.dabara.new'
  Copy-Item -Force $exe.FullName $staged
  Move-Item -Force $staged $Dest
} finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

Write-Host ''
& $Dest --version
if ($LASTEXITCODE -ne 0) { Fail 'installed, but the program does not run on this machine' }

if (-not $NoPath -and -not (Test-OnUserPath $InstallDir)) {
  $current = Get-UserPath
  $new = if ($current) { "$($current.TrimEnd(';'));$InstallDir" } else { $InstallDir }
  [Environment]::SetEnvironmentVariable('Path', $new, 'User')
  $env:Path = "$env:Path;$InstallDir"
  Write-Host ''
  Write-Host "Added $InstallDir to your user PATH. Open a NEW terminal for it to take effect everywhere."
}
Write-Host ''
Write-Host 'Try:  dabara sabo hello; cd hello; dabara gudana'
