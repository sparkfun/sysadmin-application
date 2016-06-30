# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%  Common Build Functions  %%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

<#
.SYNOPSIS
Constructs the complete version number from build definition variables.

.DESCRIPTION
Three build definition variables make up the major, minor, and patch numbers, but the changset number is gathered from
the build system's default environment variables. All four parts are environment variables, therefore none of them need
to be specified when the function is called.

.PARAMETER Commas
By default a period delimited version number will be returned, but this flag returns the version number delimited by
commas. This is a logical flag, so it takes no input. This option is intended for use in setting the version of a C++
project.

.EXAMPLE
Get-FullVersion
result: 5.0.0.629

.NOTES
The BUILD_SOURCEVERSION environment variable may have a preceeding "C". This function uses a substring method on the
string object to remove it.
#>
Function Get-FullVersion{
	param(
		[switch] $Commas
	)
	if($Env:BUILD_SOURCEVERSION.substring(0,1) -eq "C"){
		$Changeset = $Env:BUILD_SOURCEVERSION.substring(1)
	}
	else {
		$Changeset = $Env:BUILD_SOURCEVERSION
	}

	if($Commas){
		$FullVersion = ($Env:MajorVersion + "," + $Env:MinorVersion + "," + $Env:Patch + "," + $Changeset)
	} else {
		$FullVersion = ($Env:MajorVersion + "." + $Env:MinorVersion + "." + $Env:Patch + "." + $Changeset)
	}
	Write-Verbose "Retrieved full verision: $FullVersion"
	$FullVersion
}

<#
.SYNOPSIS
Constructs the short version number from build definition variables.

.DESCRIPTION
Two build definition variables make up the major and minor version number. Both parts are environment variables,
therefore none of them need to be specified in this script when the function is called.

.PARAMETER Commas
By default a period delimited version number will be returned, but this flag returns the version number delimited by a
comma. This is a logical flag, so it takes no input.

.EXAMPLE
Get-ShortVersion
result: 5.0

.NOTES
This will probably be deleted since it is unused. This funcition aimed to reproduce the old Master Build Script.
#>
Function Get-ShortVersion{
	param(
		[switch] $Commas
	)
	if($Commas){
		$ShortVersion = ($Env:MajorVersion + "," + $Env:MinorVersion)
	} else {
		$ShortVersion = ($Env:MajorVersion + "." + $Env:MinorVersion)
	}
	Write-Verbose "Retrieved short verision: $ShortVersion"
	$ShortVersion
}

#####################
##  API Functions  ##
#####################

<#
.SYNOPSIS
Returns the authentication header for use a VSTS API call.

.DESCRIPTION
A build definition can allow the build agent scripts access to its authentication token. This function uses that
token to generate a header object withe the build agent credentials. The build definition must allow access
to OAuth token to make API calls.

.LINK
https://www.visualstudio.com/en-us/docs/build/scripts/index#use-the-oauth-token-to-access-the-rest-api

.NOTES
In the absense of an access token, a username and password are passed to the server. For testing, replace these with
your Microsoft ID and a token generated for your account and comment out the "Write-Error" line in the else block. Do 
NOT check in testing credentials. This 
#>
function Get-RequestHeader {
    if($Env:SYSTEM_ACCESSTOKEN){
        Write-Verbose "Using sysem access token for API call"
		return @{"Authorization"="Bearer $Env:SYSTEM_ACCESSTOKEN"}
	} else {
		Write-Error "System Access Token not available"
		$user = 'user'
		$pass = 'pass'

		$pair = "$($user):$($pass)"

		$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

		$basicAuthValue = "Basic $encodedCreds"

		return @{"Authorization"= $basicAuthValue }
	}
}

<#
.SYNOPSIS
Returns object of build definitions that include the value of the Name argument

.DESCRIPTION
This cmdlet is used to search build definitions by name. It returns the value object from a web request.

.PARAMETER Name
Some part of the build definition name to search for. 

.LINK
https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#get-a-list-of-build-definitions

.NOTES
Useful for finding related build artifacts, such as SSCCore.
#>
Function Get-VSTSBuildDefinitions {
    param(
        [string]$Name
	)
    [System.Uri]$Uri = "https://somesoftwarecompany.visualstudio.com/DefaultCollection/SyncApp/_apis/build/definitions"
    $Body = @{"api-version" = "2.0"}
    if($Name){
        $Body.Add("name", $Name)
        Write-Verbose "Querying build definitions for '$Name'."
    }
    else { 
        Write-Verbose "Querying for all build definitions."
    }
    $WebRequest = Invoke-RestMethod -Uri $Uri -Method Get -Headers (Get-RequestHeader) -Body $Body
	if($WebRequest.count -gt 0){
		Write-Verbose "API call retrieved $($WebRequest.count) build definitions."
	    $WebRequest.value
	} else {
		Write-Error "Get-VSTSBuildDefinitions found no results for name '$Name'."
	}
}

<#
.SYNOPSIS
Returns request result for latest successful build.

.DESCRIPTION
This function calls the "builds" api with filters of the provided build 
definition ID, the build result is "Succeeded" and only return 1 result. The
Return value is the entire response from the request

.PARAMETER DefinitionID
Integer ID of a valid build definition

.LINK
https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-list-of-builds

.NOTES
This intended for getting the latest Core build, but might be useful for 
another unforseen scenario.

#>
Function Get-VSTSLatestSuccessulBuild {
    param(
        [Parameter(Mandatory=$true)][Int]$DefinitionID
	)
    Write-Host "Finding latest successful build"
    [System.Uri]$Uri = "https://somesoftwarecompany.visualstudio.com/DefaultCollection/SyncApp/_apis/build/builds"
    $Body = @{
        "api-version" = "2.0";
        "definitions" = $DefinitionID;
        "resultFilter" = "succeeded";
        '$top' = 1
    }
    Write-Verbose "Querying API for latest good build for build definition ID '$DefinitionID'."
    $WebRequest = Invoke-RestMethod -Uri $Uri -Method Get -Headers (Get-RequestHeader) -Body $Body
    Write-Verbose "API call retrieved $($WebRequest.count) builds."
    return $WebRequest.value
}

<# 
.SYNOPSIS
Gets artifact information about a single build.

.DESCRIPTION
Given a build ID, this function calls the VSTS builds API to retreive info
about artifacts of a singe build. The "value" portion of the response is returned.

There are 2 logging statements and no verbose statements.

.PARAMETER BuildID
Integer ID number of the build.

.EXAMPLE
Get-VSTSBuildArtifacts -BuildID 1045

Returns array of objects for each artifact uploaded in build 1045.

.LINK
https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-build-artifacts
#>
Function Get-VSTSBuildArtifacts {
    param(
        [Parameter(Mandatory=$true)][Int]$BuildID
	)
    Write-Host "Querying for build artifacts"
    [System.Uri]$Uri = "https://somesoftwarecompany.visualstudio.com/DefaultCollection/SyncApp/_apis/build/builds/$BuildID/artifacts"
    $Body = @{
        "api-version" = "2.0";
    }
    $WebRequest = Invoke-RestMethod -Uri $Uri -Method Get -Headers (Get-RequestHeader) -Body $Body
    Write-Host "Found $($WebRequest.count) artifact(s)."
    return $WebRequest.value
}

<#
.SYNOPSIS
Downloads a specific artifact from a VSTS build.

.DESCRIPTION
This function takes a custom object representing a single artifact and a file
path to the download destination. 

.PARAMETER FilePath
Path to download destination. The downloaded file name and extension are
automatic, so do not specify that.

.PARAMETER SingleArtifact
This object must follow the structure of the response from the VSTS builds API
request for artifacts. The folling structure is used in the function: 

"artifact": {
    "name": "Artifact Name"
    "resource": {
        "downloadUrl": "https://someValidUrl"
    }
}

.EXAMPLE
Download the latest release build of SSC.Core Main assemblies:

# find the artifact download url
$SscCoreMainId = 2
$latestGoodBuild = Get-VSTSLatestSuccessulBuild -DefinitionID $SscCoreMainId
$artifacts = Get-VSTSBuildArtifacts -BuildID $latestGoodBuild.id

# find artifacts with "release" in the name and download
$artifacts | % {
    if($_.name -like "*release*"){
        Download-SingleArtifact -FilePath "c:\my\download\path" -SingleArtifact $_
    }

.NOTE
This is intended for use by another function.
#>
Function Download-SingleArtifact{
    param(
        [Parameter(Mandatory=$true)][string]$FilePath,
        [Parameter(Mandatory=$true)][psobject]$SingleArtifact
    )
    if($SingleArtifact.name -like "build.SourceLabel"){
        break
    }
    if( (Test-Path "$FilePath\$($SingleArtifact.name).zip") ){
        Write-Warning "Already downloaded $($_.Name).zip. File will be deleted."
        Remove-Item "$FilePath\$($SingleArtifact.name).zip" -Force
    }
    else{
        Write-Host "Downloading $($SingleArtifact.Name).zip"
    }
    if(-not $DryRun){
		Write-Verbose "Downloading artifact $($SingleArtifact.Name)"
        Invoke-WebRequest -Uri $SingleArtifact.resource.downloadUrl -Headers (Get-RequestHeader) -Method Get -OutFile "$FilePath\$($SingleArtifact.name).zip"
    }
}

<#
.SYNOPSIS
Downloads build artifacts from latest successful build of a specific build definition

.DESCRIPTION
This function ties together several other funcitons to download artifacts with
a specified name. 

.PARAMETER BuildDefinitionId
Integer ID of the build definition

.PARAMETER FilePath
Path to download directory. Do not specify file name here. 

.PARAMETER SingleArtifactName
String to match artifact name.

.EXAMPLE
Download the latest good build of SSC.Core assemblies.
Download-VSTSLatestArtifacts $BuildDefinitionId 2 -FilePath "c:\my\download\path" -SingleArtifact 
#>
Function Download-VSTSLatestArtifacts {
    param(
        [Parameter(Mandatory=$true)][Int]$BuildDefinitionId,
        [Parameter(Mandatory=$true)][String]$FilePath,
        [String]$SingleArtifactName,
        [switch]$DryRun
	)
    $LatestBuild = Get-VSTSLatestSuccessulBuild -DefinitionID $BuildDefinitionId
    $BuildArtifacts = Get-VSTSBuildArtifacts -BuildID $LatestBuild.id

    $BuildArtifacts | % {
        if($SingleArtifactName -and $_.Name -like $SingleArtifactName){
            Download-SingleArtifact -SingleArtifact $_ -FilePath $FilePath
			Write-Verbose "Single artifact selected"
        }elseif(-not $SingleArtifactName -and $_.name -notlike "build.SourceLabel"){ 
            Download-SingleArtifact -SingleArtifact $_ -FilePath $FilePath
        }
    }
}


###############
##  Logging  ##
###############

<#
.SYNOPSIS
Produces a title and border in three lines of text.

.DESCRIPTION
This function prints a border of characters around a given string of text.
The border character defaults to # if not specified. Inetended for use in 
logs to highlight the start of major steps. 

.PARAMETER Text
String of title to display

.PARAMETER Character
If specified, the border will consist of this character. Enclose character
in single quotes.

.EXAMPLE
Write-Title -Text "My Fancy Title"

result:

######################
##  My Fancy Title  ##
######################

.EXAMPLE
Write-Title -Text "Mo Money Mo Problems" -Character '$'

result:

$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$  Mo Money Mo Problems  $$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#>
Function Write-Title {
	param(
		[Parameter(Mandatory=$true)]
		[string]$Text,
		[char]$Character = '#'
	)
	Write-Bar -Count ($Text.Length + 8) -Character $Character
	Write-Host "$Character$Character  $Text  $Character$Character"
	Write-Bar -Count ($Text.Length + 8) -Character $Character
}

<#
.SYNOPSIS
Prints single character specified number of times on one line.

.DESCRIPTION
This function prints a line of a repeated character for the specified number of
iterations. 

.PARAMETER Count
Integer number of times to repeat character

.PARAMETER Character
Character to print. If not specified, # is the default. Enclose character
in single quotes.

.EXAMPLE
Write-Bar -Count 15

result:

###############

.EXAMPLE
Write-Bar -Count 12 -Character '^'

result:

^^^^^^^^^^^^
.NOTES
This is intended for use by another function.
#>
Function Write-Bar {
	param(
		[Parameter(Mandatory=$true)]
		[int]$Count,
		[char]$Character = '#'
	)
	1..$Count | % { $bar += $Character}
	Write-Host $bar
}
