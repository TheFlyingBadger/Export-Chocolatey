# Export-Chocolatey

This exports the list of your currently installed [Chocolatey](https://chocolatey.org/) packages to a pair of [.config files](https://docs.chocolatey.org/en-us/choco/commands/install#packages.config).


run `export-chocolatey.ps1` (***or*** `export-chocolatey.bat` ***if you prefer***) and it will export your currently installed packages, a log file (`export.<<MACHINENAME>>.config`) will also be produced


To install the latest versions of all packages 


`   choco install export.<<MACHINENAME>>.config -y`

 or, if you want the specific current versions 

`   choco install export.<<MACHINENAME>>.versioned.config -y`
