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
            #[ValidateScript({Test-Path $_ -PathType 'leaf'})]  
            [string] $Path,
            [Switch] $UpdateFile
    )

    Begin{    
            If(-not (Get-Module -Name 'PSScriptAnalyzer'))
            {
                If(-not (Import-Module PSScriptAnalyzer -Verbose -ErrorAction SilentlyContinue -PassThru))
                {
                    Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -Verbose -ErrorAction SilentlyContinue
                }
            }
    }
    Process{
                ForEach($P in $Path)
                {
                    $P = Convert-Path -Path $P
                    $Reader = [system.io.file]::OpenText($P)

                    $RequiredFixes = Invoke-ScriptAnalyzer -Path $P | `
                    Where-Object {$_.RuleName -eq "PSAvoidUsingCmdletAliases"} | `
                    Select-Object @{n='Target';e={$_.extent}}, `
                    @{n='Correction';e={$_.SuggestedCorrections.text}}, `
                    @{n='StartLineNumber';e={$_.SuggestedCorrections.StartLinenumber}}

                    $i = 1
                    $Result = @()
                    While($Reader.Peek() -gt 0)
                    {
                        $Line = $Reader.ReadLine()
                        If($i -in $RequiredFixes.StartLineNumber)
                        {
                            $Item = $RequiredFixes|Where-Object {$_.StartLinenumber -eq $i}
                            Foreach($CurrentItem in $Item | Select-Object target, correction -Unique)
                            {
                                $Line = $Line -replace [Regex]::Escape($CurrentItem.target.text) , $CurrentItem.Correction 
                            }                        
                            $Result =  $Result + $Line
                        }
                        else
                        {
                            $Result =  $Result + $Line    
                        }
                        $i=$i+1
                    }
                    # Close the reader to release the Handle on file before updating it
                    $Reader.Close()

                    If($UpdateFile)
                    {
                        $Result | Out-File $P -Force -Verbose
                    }
                    $Result
                }
    }
    End{}

}

# ls | ForEach-Object {Invoke-ScriptAnalyzer -Path $_.FullName} |group Rulename |sort -Descending count
