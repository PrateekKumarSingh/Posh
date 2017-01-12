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
        $Results = Invoke-WebRequest "http://sentence.yourdictionary.com/$Word"
    }
    catch
    {
        Write-host $_ -ForegroundColor Red
    }
    
    $i=0
    If($Results.StatusCode -eq 200)
    {
        Foreach($Sentence in ($Results.ParsedHtml.getElementsByTagName('Div')| Where{$_.ClassName -eq 'li_content'}|Get-Random -Count $count))
        {
            $i=$i+1
            ''|Select @{n='#';e={$i}},
                      @{n='WordCount';e={$Sentence.textContent.Split(' ').count}},
                      @{n='Sentence';e={$Sentence.textContent}}
        }
    }
    else
    {
        Write-Host "Couldn't find any sentences for word : $Word" -ForegroundColor Red
    }
   
}
