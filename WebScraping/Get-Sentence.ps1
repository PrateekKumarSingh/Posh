Function Get-Sentence
{
    [cmdletBinding()]
    [alias('gs')]
    param(
            [parameter(mandatory=$true)] [String]$Word,
            [int] $count = 10,
            [int] $MaxWords
    )

    Try
    {
        $Results = Invoke-WebRequest "http://sentence.yourdictionary.com/$Word" -TimeoutSec 5 -DisableKeepAlive
    }
    catch
    {
        Write-host $_ -ForegroundColor Green
    }
    
    $i=0
    If(-not $Results)# -and $Results.StatusCode -eq 200)
    {
            Write-Host "Couldn't find any sentences for word : $Word" -ForegroundColor Red
    }
    else
    {
        Foreach($Sentence in ($Results.ParsedHtml.getElementsByTagName('Div')| Where{$_.ClassName -eq 'li_content'}|Get-Random -Count $count))
        {
            $i=$i+1
            $WordCount = $Sentence.textContent.Split(' ').count
            If($MaxWords -and $WordCount -le $MaxWords)
            {
                ''|Select @{n='#';e={$i}},
                          @{n='WordCount';e={$WordCount}},
                          @{n='Sentence';e={$Sentence.textContent}}
            }
            elseif(-not $MaxWords)
            {
                ''|Select @{n='#';e={$i}},
                          @{n='WordCount';e={$WordCount}},
                          @{n='Sentence';e={$Sentence.textContent}}
            }
        }
    }
   
}
