Set-Alias -Name npp -Value "C:\Program Files\Notepad++\notepad++.exe"

function Open-Explorer {
    param (
        [string]$Path = "."
    )
    
    $resolvedPath = Resolve-Path -Path $Path
    
    Start-Process explorer.exe -ArgumentList $resolvedPath.Path
}
Set-Alias -Name e -Value Open-Explorer

function acm {
    param ([string]$message)
    git add .
    git commit -m $message
}

function cm {
    param ([string]$message)
    git commit -m $message
}

function cam {
    param ([string]$message)
    git add .
    git commit --amend -m $message
}

Set-Alias -Name help -Value Get-Alias -Force