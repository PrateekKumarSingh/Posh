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
            if($i -eq 13)
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
    
        $TotalLength = 0
               
        $_.split() | `
        where{-not [string]::IsNullOrWhiteSpace($_)} | ` #Filter-out whiteSpaces
        ForEach-Object{
                        if($TotalLength -lt ($Host.ui.RawUI.BufferSize.Width-10))
                        {
                            #"TotalLength : $TotalLength"
                            $Token =  $_
                            
                            Foreach($Word in $Words)
                            {
                                if($Token -like "*$Word*")
                                {
                                    $Before, $after = $Token -Split "$Word"
                                        
                                    "[$Before][$Word][$After]`n"
                                    
                                    Write-Host $Before -NoNewline ; 
                                    Write-Host $Word -NoNewline -Fore Black -Back $ColorLookup[$Word];
                                    Write-Host $after -NoNewline ;                                    
                                    Start-Sleep -Seconds 1    
                                    break  
                         
                                }
                            }    
                            Write-Host "$Token " -NoNewline                                    
                            $TotalLength = $TotalLength + $Token.Length  + 1
                        }
                        else
                        {                      
                            Write-Host '' #New Line  
                            $TotalLength = 0 

                        }

                            #Start-Sleep -Seconds 0.5
                        
        }
        Write-Host '' #New Line               
    }
    }
    end
    {    }

}

gc C:\Temp\doc.txt | Trace-Word -words "trump","hillary","FBI","Emails"

gc .\log.txt |Trace-Word -words "IIS", "exe", "10", 'system'

gc .\log.txt | Trace-Word -words "random","more","on",'of','end','logging','is','a','test','log','some','information','this','file','and','goes'
