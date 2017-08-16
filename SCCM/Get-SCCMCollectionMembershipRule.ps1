Function Get-SCCMCollectionMembershipRule
{
[cmdletbinding()]
param(
        # Enter the CollectionName code like DHB , EQT etc
        [Parameter(Mandatory=$true)]
        [String]
        $CollectionName
)

$Path =  (Get-Location).path
$ScriptBlock = [Scriptblock]{
    Write-Verbose "ConfigurationManager v$($Module.Version) found. Proceeding."
    Set-Location "$((Get-PSDrive -PSProvider CMSite).name):\"
    Write-Verbose "Filtering SCCM Device collections and Membership Rules by *$CollectionName*"
    $MemberShipRule  =  Get-CMDeviceCollection -name "*$CollectionName*"|`
                        Where {$_.CollectionRules.RuleName -ne $null} |`
                        Foreach {Get-CMDeviceCollectionQueryMembershipRule -CollectionID $_.CollectionID }

    If($MemberShipRule)
    {
        Write-Verbose "Extracting Query Expression from Membership Rules"
        ($MemberShipRule.queryexpression.split(',')).where({$_ -like "*%*%*"}).Foreach({
            (($_ -split 'where')[1] -split "_")[-1]
        })
    }
    Else{
        Write-Host "No membership rule found on device collection names like *$CollectionName*" -ForegroundColor Yellow
    }
 
    Set-Location $Path
}
$Module = Get-Module 'ConfigurationManager'

If(-not $Module)
{
    Write-Verbose "Importing ConfigurationManager Module."
    Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' -ErrorAction SilentlyContinue
    If(-not $?){     
        Write-Error "Unable to find 'ConfigurationManager' module on local machine"
    }
    else{
            & $ScriptBlock
    }
}
else{
        & $ScriptBlock
}

}
