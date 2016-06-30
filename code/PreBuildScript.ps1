#  %%%%%%%%%%%%%%%%%%%%%%%
#  %%  PreBuild Script  %%
#  %%%%%%%%%%%%%%%%%%%%%%%

# Enable verbose printing and print all environment variables
if($env:SYSTEM_DEBUG -like "true"){ 
	$VerbosePreference = "Continue"
	Get-ChildItem env:
}

Import-Module ".\Shared Resources\Build Resources\Scripts\CommonBuildFunctions.psm1"

# Enable zip file manipulation
Add-Type -assembly "system.io.compression.filesystem"

# Call function once instead of a dozen
$FullVersion = Get-FullVersion

########################
##  Define Functions  ##
########################
<#
.SYNOPSIS
Sets text for assembly information properties

.DESCRIPTION
This function takes the text of an assembly info file, modifies content with
regex search and replace, and then returns the text. 

AssemblyCompany is hard coded since the company name shouldn't change.
AssemblyCopyright injects the current year into the boilerplate copyright.
AssemblyVersion and AsseblyFile version are the full version of the build.

.PARAMETER FileContent
Text extracted from the AssemblyInfo.cs file.

.NOTE
This function is broken out of Update-AssemblyInfoFile to reduce arrow code.
#>
function Update-AssemblyInfoProperties{
	param(
		[Parameter(Mandatory=$true)]$FileContent
	)
	$AssemblyInfoPropterties = @(
		New-Object -TypeName psobject -Property @{
            Name = "AssemblyCompany"
			NewVal = 'Some Software Company, Inc.'
        }
		New-Object -TypeName psobject -Property @{
            Name = "AssemblyCopyright"
            NewVal = "Copyright ©$(Get-Date -UFormat %Y) Some Software Company, Inc."
        }
		New-Object -TypeName psobject -Property @{
            Name = "AssemblyVersion"
            NewVal = $FullVersion
        }
		New-Object -TypeName psobject -Property @{
            Name = "AssemblyFileVersion"
            NewVal = $FullVersion
        }
	)

	foreach($Property in $AssemblyInfoPropterties){
        $Regex = "$($Property.Name)\(\"".+?""\)"
        $NewVal = "$($Property.Name)(""$($Property.NewVal)"")"
		$FileContent = $FileContent -Replace $Regex, $NewVal
        Write-Verbose " - changed $($Property.Name) to $($Property.NewVal)"
    }
	$FileContent
}

<#
.SYNOPSIS
Reads file content, sends to Update-AssemblyInfoProperties for update, then saves.

.DESCRIPTION
This function handles the read write file operations of updating assembly info,
but it calls another function to edit the content. It is intended to serve this
funcion for anothe script.

.PARAMETER AssemblyInfoFile
The filesystem object that represents the AssemblyInfo.cs file.

.NOTES
This is intended for use by another function.
#>
function Update-AssemblyInfoFile{
	param(
		[Parameter(Mandatory=$true)]$AssemblyInfoFile
	)
	
	Write-Host "Updating " $AssemblyInfoFile.FullName
	[string]$FileContent = Get-Content -Raw $AssemblyInfoFile.FullName
    
	$FileContent = Update-AssemblyInfoProperties -FileContent $FileContent

	attrib.exe $AssemblyInfoFile.FullName -R
	$FileContent | Out-File $AssemblyInfoFile.FullName
}

<#
.SYNOPSIS
Finds AssemblyInfo files and updates them.

.DESCRIPTION
This function searches the build sources directory for any file named 
"AssemblyInfo.*". It passes each file to Update-AssemlbyInfoFile for modification
#>
function Update-AssemblyInfo{
	Write-Title -Text "Updating Assembly Info"
	$files = Get-ChildItem -Path $Env:BUILD_SOURCESDIRECTORY -Recurse "AssemblyInfo.*"
	$files | % { Update-AssemblyInfoFile -AssemblyInfoFile $_ }
}

<#
.SYNOPSIS
Modifies project files for a successful build.

.DESCRIPTION
Since the build is largely configured by the project files, this script changes
some key elements to ensure some common pitfalls don't cause breakage. 

The script creates an array of all csproj files in the build sources directoy.
Each file in the array is passed to two functions for processing:
	Remove-RegisterForComInterop prevents a build failure because the build
		agent does not have admin rights necessary to complete that registration.
	Remove-EsriRegasm similarly prevents a post build step that requires 
		elevated privileges.
#>
function Update-ProjectFiles{
	Write-Title -Text "Updating csproj files"
	$ProjectFiles = Get-ChildItem -Path $Env:BUILD_SOURCESDIRECTORY -Recurse "*.csproj"
	foreach($ProjectFile in $ProjectFiles) {
		$ProjectXml = New-Object xml
		$ProjectXml.Load($ProjectFile.FullName)
		Write-Verbose "Updating $($ProjectFiles.Name)"
		$ProjectXml = Remove-RegisterForComInterop -ProjectXml $ProjectXml
		$ProjectXml = Remove-EsriRegasm -ProjectXml $ProjectXml
		$ProjectXml.Save($ProjectFile.FullName)
	}
	Write-Host "Found and checked/updated $($ProjectFiles.Length) project files."
}

<#
.SYNOPSIS
Removes the RegisterForComInterop flag in the specified project XML.

.DESCRIPTION
This function modifies a specified XML object to set elements named
RegisterForComInterop to false.

Register for COM interop only affects the machine on which it runs. This requires
elevated privileges to modify certain registry keys. Since this is not useful 
and the build agend runs with a service account that is on an administrator, 
it must be removed.

.PARAMETER ProjectXml
This System.Xml.XmlDocument should have loaded a csproj file for modification.

.NOTES
This is intended for use by another function.
#>
function Remove-RegisterForComInterop{
	Param(
		[Parameter(Mandatory=$true)]
		[xml]$ProjectXml
	)
		foreach ($PropertyGroup in $ProjectXml.Project.PropertyGroup) {
			if($PropertyGroup.RegisterForComInterop -and $PropertyGroup.RegisterForComInterop -like "true"){
				Write-Verbose " + Removing register for com interop."
				$PropertyGroup.RegisterForComInterop = "false"
			}
			else{
				Write-Verbose " -  This project not set to register for com interop."
			}
		}
	return $ProjectXml
}

<#
.SYNOPSIS
Removes any target that include the string "esriregasm".

.DESCRIPTION
This function iterates through target elements to test for the string
"esriregasm". If found, the command is replaced with "echo Command removed"

ArcMap is not installed on the build agent, and even if it was, there is no
reason to register arc extenstions on a computer that no one uses.

.PARAMETER ProjectXml
This System.Xml.XmlDocument should have loaded a csproj file for modification.

.NOTES
This is intended for use by another function.
#>
function Remove-EsriRegasm{
	Param(
		[Parameter(Mandatory=$true)]
		[xml]$ProjectXml
	)
		foreach($target in $ProjectXml.Project.Target){
			if($target.exec.command -like "esriregasm*"){
				$target.exec.command = "echo Command removed"
				$target.exec.WorkingDirectory = "c:\"
				Write-Verbose " + Removed EsriRegAsm"
			}
			else{
				Write-Verbose " -  This target is not set to run EsriRegAsm"
			}
		}
	return $ProjectXml
}

<#
.SYNOPSIS
Set the name of the output of an installer project.

.DESCRIPTION
This function takes the xml of a wixproj file and modifies the output string.
It assumes the present name is correct and appends the full version number.
If the build configuration is anything other than "Release", it also appends
that build configuration name.

.PARAMETER Wixproj
This System.Xml.XmlDocument should have loaded a wixproj file for modification.

.NOTES
This is intended for use by another function.
#>
function Set-InstallerOutputName{
	Param(
		[Parameter(
			Mandatory=$true, 
			ValueFromPipeline=$true)]
		[xml]$Wixproj
	)
	Write-Verbose "Updating installer output name"
	$Wixproj.project.propertygroup[0].outputName += (" " + $FullVersion)
	if ($env:BUILDCONFIGURATION -notlike "Release"){
		Write-Verbose "Appending '$env:BUILDCONFIGURATION'"
		$Wixproj.project.propertygroup[0].outputName += " $env:BUILDCONFIGURATION"
	} else {Write-Verbose "Configuration is 'Release'. Nothing more to append"}
	return $Wixproj
}

<#
.SYNOPSIS
Sets version of installer in wixproj.

.DESCRIPTION
This function sets the correct version in the wix source files. A source file's 
version attribute is used for upgrades and other important installer operations.

Since the project files reference the source files, this script concatenates
the project directory with the source's reference path to locate the file.
Located files load into an XML object for modification.

.PARAMETER Wixproj
This System.Xml.XmlDocument should have loaded a wixproj file for modification.

.PARAMETER Directory
String of the directory in which the wixproj resides.

.NOTES
This is intended for use by another function.
It also needs to be divided to reduce arrow code.
#>
function Set-InstallerVersion{
	[cmdletbinding()]
    Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][xml]$Wixproj,
        [Parameter(Mandatory=$true)][string]$Directory
        
	)
    if(-not (Test-Path $Directory)){ Write-Error "Set-InstallerVersion: Search directory is not a valid path."}
	$Wixproj.project.itemgroup | % {
        if($_.Compile){
        Write-Verbose "checking $($_.Name) for source files"
		    foreach($Compile in $_.Compile){
                $FilePath = "$Directory\$($Compile.Include)"
                if(Test-Path $filePath){
                    Write-Verbose "Updating version to $FullVersion in installer source file: $FilePath"
                    [xml]$WixSource = Get-Content $FilePath
					try{
						$WixSource.Wix.Product.Version = $FullVersion
						$WixSource.Save($FilePath)
					}catch{
						try{
							$WixSource.Wix.Bundle.Version = $FullVersion
							$WixSource.Save($FilePath)
						}catch{
							Write-Verbose "Wix source did not have a Product or Bundle element"
						}
					}
                }
                else
                {
                    Write-Verbose "Cannot find $FilePath"
                }
            }
        }
	}
}

<#
.SYNOPSIS
Supresses installer validation.

.DESCRIPTION
While installer valitation is a good thing, leaving it enabled causes build 
failure. Installer validation runs the installer database agains the 
Windows Installer Service, which requires elevated privilege. Since the build
agent runs as a service account without admin privilege, that step of the
build fails when nothing is actully wrong.

Please validate the installer on a desktop before checking in.

.PARAMETER Wixproj
This System.Xml.XmlDocument should have loaded a wixproj file for modification.

.NOTES
This is intended for use by another function.
#>
function Set-SupressInstallerValidation{
	[cmdletbinding()]
    Param(
		[Parameter(
			Mandatory=$true, 
			ValueFromPipeline=$true)]
		[xml]$Wixproj
	)
    $warn = $true
    $Wixproj.project.propertygroup | % {
        if($_.SuppressValidation){
		    Write-Verbose "Suppressing Validation"
		    $_.SuppressValidation = "true"
            $warn = $false
        }
    }
    if($warn){Write-Warning -Message "Installer not suppressing validation"}
	return $Wixproj
}

<#
.SYNOPSIS
Searches for wixproj files and calls modifier functions on them.

.DESCRIPTION
This function searches the build sources directory for files with the wixproj
extension. It then passes the file content to various modivier functions
before saving the content to the original file.

#>
function Update-Installer{
	Write-Title -Text "Updating installer projects"
	$files = Get-ChildItem -Path $Env:BUILD_SOURCESDIRECTORY -Recurse "*.wixproj" | Where-Object {$_.FullName -notlike "*Shared Resources*"}
	if($files.Length -gt 0){
		$files | %{
			Write-Verbose ("Updating " + $_.FullName)
			[xml]$content = Get-Content $_.FullName
			$content = Set-SupressInstallerValidation -Wixproj $content
			$content = Set-InstallerOutputName -Wixproj $content
			Set-InstallerVersion -Wixproj $content -Directory $_.Directory
			$content.save($_.FullName)
		}
	} else {
		Write-Host "No Wix projects found."
	}
}

<#
.SYNOPSIS
Replaces infragistics license files with empty file.

.DESCRIPTION
This function finds license files, evaluates size and if larger than 0, passes
the file object to the Replace-LicenseFile function.

Using Infragistics in visual studio creates entries in a license file.
Attempting to compile with a populated license file and without a licensed 
installation of Infragistics causes the build to break. However, an empty 
file of the same name will restore the build success.

#>
function Empty-InfragisticsLicenses{
	Write-Title -Text "Replace Infragistics license files"
	$LicenseFiles = Get-ChildItem -Path $Env:BUILD_SOURCESDIRECTORY -Recurse "licenses.licx" | Where-Object {$_.Length -gt 0}
	Write-Host "Found $($LicenseFiles.Length) license files" 
	$LicenseFiles | % {Replace-LicenseFile -LicenseFile $_}
}

<#
.SYNOPSIS
Forcibly copies empty file over specified license file.

.DESCRIPTION
This function copies an empty license file over the specified license file.

.PARAMETER LicenseFile
File object of offending license file.

.NOTES
This is intended for use by another function.
#>
function Replace-LicenseFile{
	Param(
        $LicenseFile
    )
	Write-Verbose "Removing $($_.FullName)"
	$BlankLicenseFile = Get-Item "$($Env:BUILD_SOURCESDIRECTORY)\Shared Resources\Infragistics\licenses.licx"
	Copy-Item -Force -Path $BlankLicenseFile -Destination $LicenseFile.FullName -Verbose
}

<#
.SYNOPSIS
Finds appropriate branch of SSC.Core from element in project files.

.DESCRIPTION
This function finds the branch of SSC.Core used in the project file by the
referenced assemblies. This ensures there is never a mismatch on the build
system because it is maintained as a part of development.
#>
function Get-SSC.CoreBranch {
	Write-Title -Text "Retrieving Branch of SSC.Core"
	$ProjectFiles = Get-ChildItem -Path $Env:BUILD_SOURCESDIRECTORY -Recurse "*.csproj"
	foreach($ProjectFile in $ProjectFiles) {
		$ProjectXml = New-Object xml
		$ProjectXml.Load($ProjectFile.FullName)
		Write-Verbose "Checking $($ProjectFile.Name)"
		if($ProjectXml.Project.PropertyGroup[0].SSC.CoreBranch){
			Write-Host "Found branch $($ProjectXml.Project.PropertyGroup[0].SSC.CoreBranch)"
			return $ProjectXml.Project.PropertyGroup[0].SSC.CoreBranch
		}
	}
	return $false
}

<#
.SYNOPSIS
Locate, download, and extract correct branch, platform and configuration of SSC.Core

.DESCRIPTION
This function uses API functions from the CommonBuildFunctions module to get the
correct build of SSC.Core for the application that needs it.

.PARAMETER Branch
String to specify which branch to download.
#>
function Download-LatestSscCore {
	param(
        [Parameter(Mandatory=$true)][String]$Branch
        )
	Write-Title "Getting Latest SSC.Core Binaries"

	$BuildDefintions = Get-VSTSBuildDefinitions -Name "SSC.Core $Branch"
	if($BuildDefintions.Length -gt 1){
		$BuildDefintions | % {
			Write-Verbose "Found $($_.Name)"
		}
		Write-Error "Query found too many build definitions for search term 'SSC.Core $Branch'" -ErrorAction Stop
	}
	Write-Host "Downloading $($BuildDefintions[0].Name)"
    $SSC.CoreBinDir = "$Env:BUILD_SOURCESDIRECTORY\SSC.Core\$Branch\bin"
	$ArtifactName = "SSC.Core-$Branch-$Env:BuildPlatform-$Env:BuildConfiguration"
	Download-VSTSLatestArtifacts -BuildDefinitionId $BuildDefintions[0].id -FilePath "$Env:BUILD_SOURCESDIRECTORY\SSC.Core" -SingleArtifactName $ArtifactName
	if((Test-Path "$Env:BUILD_SOURCESDIRECTORY\SSC.Core\$ArtifactName.zip")){
        if((Test-Path "$SSC.CoreBinDir\$Env:BuildPlatform\$Env:BuildConfiguration")){
            Write-Warning "$SSC.CoreBinDir\$Env:BuildPlatform\$Env:BuildConfiguration exists. Deleting directory and contents"
            Remove-Item "$SSC.CoreBinDir\$Env:BuildPlatform\$Env:BuildConfiguration" -Recurse -Force
		}elseif((Test-Path "$SSC.CoreBinDir\$Env:BuildPlatform")){
            Write-Verbose "Platform directory exists"
        }else{
			Write-Host "Creating SSC.Core $Branch branch directory."
			New-Item -ItemType Directory -Path "$SSC.CoreBinDir" -Name "$Env:BuildPlatform"
		}
		Write-Verbose "Unzipping SSC.Core branch '$Branch'."
		[io.compression.zipfile]::ExtractToDirectory(
            "$Env:BUILD_SOURCESDIRECTORY\SSC.Core\$ArtifactName.zip",
            "$SSC.CoreBinDir\$Env:BuildPlatform"
        )
        Rename-Item "$SSC.CoreBinDir\$Env:BuildPlatform\$ArtifactName" "$SSC.CoreBinDir\$Env:BuildPlatform\$Env:BuildConfiguration" -Force
	} else{
		Write-Verbose "Artifact name: $ArtifactName"
		Write-Warning "SSC.Core artifacts for branch '$Branch' were not downloaded."
		Write-Error "Failed to test path for $ArtifactName.zip" -ErrorAction Stop
	}
}

######################
##  Call Functions  ##
######################
Update-AssemblyInfo
Update-Installer
Empty-InfragisticsLicenses
Update-ProjectFiles
$SSC.CoreBranch = Get-SSC.CoreBranch
if($SSC.CoreBranch){
	Download-LatestSscCore -Branch $SSC.CoreBranch
}

#####################
##  Special Cases  ##
#####################
if($Env:BUILD_DEFINITIONNAME -like "Sync App*"){
	Write-Verbose "Updating Sync App version number."
	$SSResourceScriptPath = "$Env:BUILD_SOURCESDIRECTORY\Sync App\$Env:BRANCH\SyncApp\SyncApp1.rc"
	$SSResourceScript = Get-Content $SSResourceScriptPath
	$SSResourceScript = $SSResourceScript.replace('5.0.0.0', $FullVersion)
	$SSResourceScript = $SSResourceScript.replace('5,0,0,0', (Get-FullVersion -Commas))
	$SSResourceScript | Set-Content $SSResourceScriptPath
}