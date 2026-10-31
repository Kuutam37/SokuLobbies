$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$exe = Join-Path $PSScriptRoot 'SokuLobbiesServer.exe'
if (-not (Test-Path -LiteralPath $exe)) { throw "SokuLobbiesServer.exe is missing." }

function Read-Integer([string]$prompt, [int]$minimum, [int]$maximum) {
    $raw = Read-Host $prompt
    $number = 0
    if (-not [int]::TryParse($raw, [ref]$number) -or $number -lt $minimum -or $number -gt $maximum) {
        throw "Enter an integer between $minimum and $maximum."
    }
    return $number
}

$port = Read-Integer 'Server TCP port (1024-65535)' 1024 65535
$slots = Read-Integer 'Maximum players (2-16)' 2 16
$name = Read-Host 'Lobby name (letters, numbers, space, _, ., -)'
if ($name -notmatch '^[A-Za-z0-9 _.-]{1,31}$') {
    throw 'Lobby name must be 1-31 characters (A-Z, 0-9, space, _, ., -).'
}
$secure = Read-Host 'Lobby password (1-31 characters, letters/numbers/_/-)' -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try {
    $password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}
if ($password -notmatch '^[A-Za-z0-9_-]{1,31}$') {
    throw 'Password must be 1-31 characters (A-Z, 0-9, _, -).'
}

$publish = Read-Host 'Register in the public lobby directory? (y/N)'
if ($publish -notmatch '^[yY]$') {
    $env:SOKULOBBIES_NO_REGISTER = '1'
    Write-Host 'Unlisted mode enabled (no directory registration).'
} else {
    Remove-Item Env:SOKULOBBIES_NO_REGISTER -ErrorAction SilentlyContinue
    Write-Host 'Public directory registration enabled.'
}
Write-Host "Starting server on TCP port $port. Stop with Ctrl+C."
& $exe ([string]$port) ([string]$slots) $name $password
exit $LASTEXITCODE
