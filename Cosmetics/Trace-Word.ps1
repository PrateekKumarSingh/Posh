Function Trace-Word
{
    [Cmdletbinding()]
    [Alias("Highlight")]
    Param(
            [Parameter(ValueFromPipeline=$true)] [string[]] $content,
            [String[]]$words = $(throw "Provide word[s] to be highlighted!"),
            [Switch] $MatchCase
    )
    
    Begin
    {
        if($MatchCase){$Operator = '-cin'}
        else{$Operator = '-in' }
    }
    Process
    {

    $content | ForEach-Object {
                    
        $_.split() | `
        where{-not [string]::IsNullOrWhiteSpace($_)} | ` #Filter-out whiteSpaces
        ForEach-Object{       
            If(Invoke-Expression "$_ $operator $(($words|%{"`'$_`'"}) -join ',')"){
                Write-Host "$_" -NoNewline -Fore Black -Back Yellow;
                Write-Host " " -NoNewline
            }
            else{
                Write-Host "$_ " -NoNewline
            }
        }
        Write-Host '' #New Line               
    }
    }
    end
    {    }

}
