Function Set-TFSWorkspacemappings
{
    [cmdletbinding()]
    [Alias("MapTFS")]
    Param(
            [Switch] $DoTFGetRecursive
    )

    $TFExe = "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\tf.exe"
    $arguments = "workspace /new /noprompt /collection:[TFS SERVER URL]".Split(" ")
    & $TFExe "workspaces /collection:[TFS SERVER URL]".split()
    Write-Verbose "Creating new workspace"
    & $TFExe $arguments  
    Write-Verbose "Mapping source control folders to local folders"
    & $tfExe "workfold /map $/SourceFolder1 / C:\Localfolder1".Split(" ")
    & $tfExe "workfold /map $/SourceFolder2 / E:\LocalFolder2".Split(" ")
    
    If($DoTFGetRecursive)
    {

        Foreach($Dir in "C:\Tests","C:\Imports","C:\Bin")
        {  
            Write-Verbose "Performing TF get on : $Dir"        
            & $TFExe "get $Dir /recursive /all /force".Split(" ")
        }
    }
}

<#    # load the needed client dll's
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client")

    $TFS = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer([TFS SERVER URL]")
    $VCS = $TFS.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer])
    $VCS.QueryWorkspaces([system.Management.Automation.language.Nullstring]::Value , "$env:USERDOMAIN\$env:USERNAME", $env:COMPUTERNAME)
    $VCS.DownloadFile

[Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer]
    $LocalWorkSpaces = [Microsoft.TeamFoundation.VersionControl.Client.Workstation]::Current.GetAllLocalWorkspaceInfo() | Select MappedPaths
    #>
