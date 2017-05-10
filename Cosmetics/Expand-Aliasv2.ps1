Function Expand-Alias
{
    [CmdletBinding()]
    Param( 
            [Parameter(
                Mandatory=$true,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0
                )
            ]
            [ValidateScript({Test-Path $_ -PathType 'leaf'})]  
            [string] $Path,
            [Switch] $UpdateFile
    )

    Begin{}
    Process{
                ForEach($P in $Path)
                {
                    $Reader = [system.io.file]::OpenText($P)

                    $RequiredFixes = Invoke-ScriptAnalyzer -Path $P | `
                    Where-Object {$_.RuleName -eq "PSAvoidUsingCmdletAliases"} | `
                    Select-Object @{n='Target';e={$_.extent}}, `
                    @{n='Correction';e={$_.SuggestedCorrections.text}}, `
                    @{n='StartIndex';e={$_.SuggestedCorrections.StartColumnNumber -1 }}, `
                    @{n='EndIndex';e={$_.SuggestedCorrections.EndColumnNumber - 1}}, `
                    @{n='StartLineNumber';e={$_.SuggestedCorrections.StartLinenumber}}, `
                    @{n='EndLineNumber';e={$_.SuggestedCorrections.EndlineNumber}}

                    $i = 1
                    $Result = @()
                    While($Reader.Peek() -gt 0)
                    {
                        #$i
                        $Line = $Reader.ReadLine()
                        If($i -in $RequiredFixes.StartLineNumber)
                        {
                            $Item = $RequiredFixes|Where-Object {$_.StartLinenumber -eq $i}
                            #To escape Replace the special char in
                            Foreach($CurrentItem in $Item.Target.Text |Select-Object -Unique)
                            {
                                $ToReplace = [Regex]::Escape("$($Line.substring($Line.IndexOf($CurrentItem),$CurrentItem.length))")
                                $Line = $Line -replace $ToReplace , $CurrentItem.Correction 
                            }                        
                            $Result =  $Result + $Line
                        }
                        else
                        {
                            $Result =  $Result + $Line    
                        }
                        $i=$i+1
                    }
                    $Reader.Close()
                    If($UpdateFile)
                    {
                        $Result | Out-File "$(Convert-path $P)" -Force -Verbose
                    }
                    $Result

                }
                    #$Path | Trace-Word -words $RequiredFixes.target.text
    }
    End{}

}

# ls | ForEach-Object {Invoke-ScriptAnalyzer -Path $_.FullName} |group Rulename |sort -Descending count
