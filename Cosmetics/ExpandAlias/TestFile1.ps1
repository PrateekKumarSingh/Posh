[System.Management.Automation.PSParser]::Tokenize((gc $psISE.CurrentPowerShellTab.Files.fullpath), [ref]$null) | ?{$_.type -eq 'command'} |`
 %{
    $token = $_.content

    $ResolvedCommand = (Get-Alias |Where-Object{$_.Name -eq $token}).resolvedcommand.Name
    if(-not [string]::IsNullOrEmpty($ResolvedCommand))
    {
        "$Token - $ResolvedCommand"
    }

    gci;gci;ls;ls;ls;gwmi;ls
 }
 