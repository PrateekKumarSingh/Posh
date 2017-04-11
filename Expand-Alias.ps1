Function Expand-Alias
{
    Param( 
            [Parameter(Mandatory=$true)]
            [ValidateScript({Test-Path $_ -PathType 'leaf'})]  
            [string] $Path  
    )


    Begin{}
    Process{
                $Reader = [system.io.file]::OpenText($Path)
                
                $RequiredFixes = Invoke-ScriptAnalyzer -Path $Path | `
                Where {$_.RuleName -eq "PSAvoidUsingCmdletAliases"} | `
                Select-Object @{n='Target';e={$_.extent}}, `
                @{n='Correction';e={$_.SuggestedCorrections.text}}, `
                @{n='StartIndex';e={$_.SuggestedCorrections.StartColumnNumber -1 }}, `
                @{n='EndIndex';e={$_.SuggestedCorrections.EndColumnNumber - 1}}, `
                @{n='StartLineNumber';e={$_.SuggestedCorrections.StartLinenumber}}, `
                @{n='EndLineNumber';e={$_.SuggestedCorrections.EndlineNumber}}
                
                $i = 1
                While($true)
                {
                    #$i
                    $Line = $Reader.ReadLine()
                    If($i -in $RequiredFixes.StartLineNumber)
                    {
                        $Item = $RequiredFixes|Where-Object {$_.StartLinenumber -eq $i}

                        $Line -replace "$($Line.substring($Item.StartIndex,$Item.Target.Text.Length))" , $Item.Correction
                    }
                    else
                    {
                        $Line    
                    }
                    $i=$i+1
                }

                $Reader.Close()
    }
    End{}

}

# ls | ForEach-Object {Invoke-ScriptAnalyzer -Path $_.FullName} |group Rulename |sort -Descending count
