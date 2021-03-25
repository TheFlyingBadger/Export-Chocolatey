

$thisPC                 = $env:COMPUTERNAME
$LogFile                = "export.$thisPC.log"
$ConfigFile             = "export.$thisPC.config"
$ConfigFileVersioned    = "export.$thisPC.versioned.config"

$sep = "------------------------------------------------------------------------------------"

Write-Output $sep | tee -filepath $LogFile

Add-Content $LogFile ""
Add-Content $LogFile "Currently installed packages" 
Add-Content $LogFile "----------------------------" 
Add-Content $LogFile ""

Add-Content $LogFile (choco list -lia)
Add-Content $LogFile ""

[System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
$xmldecl = $oXMLDocument.CreateXmlDeclaration("1.0", "utf-8", "yes")
[System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("packages")
$null = $oXMLDocument.InsertBefore($xmldecl, $doc.DocumentElement)
$null = $oXMLDocument.appendChild($oXMLRoot)

Foreach ($package in (choco list -lo -r -y))
{
    [System.XML.XMLElement]$oXMLPackage=$oXMLRoot.appendChild($oXMLDocument.CreateElement("package"))
    $packageArr = $package.Split("|")
    $oXMLPackage.SetAttribute("id",$packageArr[0])
    $oXMLPackage.SetAttribute("version",$packageArr[1])
}
$oXMLDocument.Save($ConfigFileVersioned)

# Create the unversioned file
$packages = $oXMLDocument.SelectNodes("//*")
foreach ($package in $packages) {
    $package.RemoveAttribute('version')
}
$oXMLDocument.Save($ConfigFile)

Add-Content $LogFile $sep
Write-Output "" | tee -Append -filepath $LogFile
Write-Output "To install the latest versions of all packages" | tee -Append -filepath $LogFile
Write-Output "" | tee -Append -filepath $LogFile
Write-Output "   choco install $ConfigFile -y"| tee -Append -filepath $LogFile
Write-Output "" | tee -Append -filepath $LogFile
Write-Output " or, if you want the specific current versions" | tee -Append -filepath $LogFile
Write-Output "" | tee -Append -filepath $LogFile
Write-Output "   choco install $ConfigFileVersioned -y"| tee -Append -filepath $LogFile
Write-Output ""| tee -Append -filepath $LogFile
Write-Output $sep | tee -Append -filepath $LogFile
Write-Output ""| tee -Append -filepath $LogFile
Write-Output "This log saved to $logFile"