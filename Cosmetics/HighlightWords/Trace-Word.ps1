Function Trace-Word
{
    [Cmdletbinding()]
    [Alias("Highlight")]
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)] [string[]] $content,
        [Parameter(Position = 1)] 
        [ValidateNotNull()]
        [String[]] $words = $(throw "Provide word[s] to be highlighted!")
    )
    
    Begin
    {        
        # preparing a color lookup table
        
        $Color = [enum]::GetNames([System.ConsoleColor]) | Where-Object {$_ -notin @('White', 'Black')} 
        [array]::Reverse($Color) # personal preference to color with lighter/dull shades at the end

        $Counter = 0
        $ColorLookup = [ordered]@{}
        foreach ($item in $words)
        {
            $ColorLookup.Add($item, $Color[$Counter])
            $Counter ++
            if ($Counter -gt ($Color.Count - 1))
            {
                $Counter = 0
            }
        }

    }
    Process
    {
        $content | ForEach-Object {
    
            $TotalLength = 0
               
            $_.split() | 
                Where-Object {-not [string]::IsNullOrWhiteSpace($_)} |  #Filter-out whiteSpaces
                ForEach-Object {
                if ($TotalLength -lt ($Host.ui.RawUI.BufferSize.Width - 10))
                {
                    #"TotalLength : $TotalLength"
                    $Token = $_
                    $displayed = $False
                            
                    Foreach ($Word in $Words)
                    {
                        if ($Token -like "*$Word*")
                        {
                            $Before, $after = $Token -Split "$Word"
                                    
                            Write-Host $Before -NoNewline ; 
                            Write-Host $Word -NoNewline -Fore Black -Back $ColorLookup[$Word];
                            Write-Host $after -NoNewline ; 
                            $displayed = $true                                   
                        }

                    } 
                    If (-not $displayed)
                    {   
                        Write-Host "$Token " -NoNewline                                    
                    }
                    else
                    {
                        Write-Host " " -NoNewline  
                    }
                    $TotalLength = $TotalLength + $Token.Length + 1
                }
                else
                {                      
                    Write-Host '' #New Line  
                    $TotalLength = 0 

                }
                        
            }
            Write-Host '' #New Line               
        }
    }
    end
    {    }
}



#Trace-Word -content (Get-Content iis.log) -words "IIS", "exe", "10", 'system'
