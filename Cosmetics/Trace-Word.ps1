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
        $Color = @{       
                    0='Yellow'      
                    1='Magenta'     
                    2='Red'         
                    3='Cyan'        
                    4='Green'       
                    5 ='Blue'        
                    6 ='DarkGray'    
                    7 ='Gray'        
                    8 ='DarkYellow'    
                    9 ='DarkMagenta'    
                    10='DarkRed'     
                    11='DarkCyan'    
                    12='DarkGreen'    
                    13='DarkBlue'        
        }

        $ColorLookup =@{}

        For($i=0;$i -lt $words.count ;$i++)
        {
            if($i -gt 13)
            {
                $j =0
            }
            else
            {
                $j = $i
            }

            $ColorLookup.Add($words[$i],$Color[$j])
            $j++
        }
        
    }
    Process
    {
    $content | ForEach-Object {
                    
        $_.split() | `
        where{-not [string]::IsNullOrWhiteSpace($_)} | ` #Filter-out whiteSpaces
        ForEach-Object{
                        $Token =  $_       
                        If($Token -in $words){
                            Write-Host "$Token" -NoNewline -Fore Black -Back $ColorLookup[$Token];
                            Write-Host " " -NoNewline
                        }
                        else{
                            Write-Host "$Token " -NoNewline
                        }
        }
        Write-Host '' #New Line               
    }
    }
    end
    {    }

}

#gc .\log.txt | Trace-Word -words "random","more","on",'of','end','logging','is','a','test','log','some','information','this','file','and','goes'

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
