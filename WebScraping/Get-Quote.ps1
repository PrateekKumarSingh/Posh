<#PSScriptInfo

.VERSION 1.0.0

.GUID 6c1560ae-2a1d-4033-a85a-1c2942b6be8a

.AUTHOR PrateekSingh

.COMPANYNAME 

.COPYRIGHT 

.TAGS Powershell  WebScraping Automation

.LICENSEURI 

.PROJECTURI https://geekeefy.wordpress.com/2017/03/07/get-quote-using-powershell/

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Get-Quote cmdlet data harvests a/multiple quote(s) from  Web outputs into your powershell console

#> 

param()

function Get-Quote
{
    [CmdletBinding()]
    [Alias("Quote")]
    [OutputType([String])]
    Param
    (
        # Topic of the Quote
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0)]
        [ValidateNotNullOrEmpty()][String[]]$Topic,
        [Parameter(Position=1)][Int]$Count = 1 ,
        [Parameter(Position=2)][Int]$Length = 150


    )

    Begin
    {

    }
    Process
    {
        Foreach($Item in $Topic)
        {
            $URL = "https://en.wikiquote.org/wiki/$Item"
            Try
            {
                $WebRequest = Invoke-WebRequest $URL
                $WebRequest.ParsedHtml.getElementsByTagName('ul')  |`
                Where-Object{$_.parentElement.id -eq "mw-content-text" -and $_.innertext.length -lt $Length} |`
                Get-Random -Count $Count |`
                ForEach-Object{ 
                                [Environment]::NewLine            
                                $_.innertext
                }
            }
            catch
            {
                $_.exception
            }
        }
    }
    End
    {
    }
}

"love", "genius"| Quote
