param(
    [Parameter(Mandatory, HelpMessage="ILRepack exe path.")]
    [string]
    $ILRepackExePath,
    [Parameter(Mandatory, HelpMessage="The build output directory.")]
    [string]
    $BuildOutputDir,
    [Parameter(HelpMessage="Ouput assembly name.")]
    [string]
    $AssemblyName
)

$BuildOutputDir = (Resolve-Path "$BuildOutputDir").Path

Write-Host ">_ Collect DLLs to merge"

$includePatterns = @(
    "System*.dll",
    "Microsoft*.dll",
    "NLog.Extensions.Logging.dll",
    "NLog.dll"
)

$itemsToMerge = Get-ChildItem -Path $BuildOutputDir -File -Include $includePatterns -Recurse
$itemsToMergeString = "";
foreach ($item in $itemsToMerge)
{
  $itemsToMergeString = $itemsToMergeString + "`"" + $item.FullName + "`"" + " "
  Write-Host "- Found merge candidate: $($item.FullName)"
}

$assemblyPath = "$BuildOutputDir\$AssemblyName.exe"
$ilRepackOutPath = "$BuildOutputDir\Merged"
$mergedAssemblyPath = "$ilRepackOutPath\$AssemblyName.exe"

# Erase ouptput dir and create a new one.
if (Test-Path $ilRepackOutPath) {
    Remove-Item -Recurse $ilRepackOutPath -Force
}

New-Item -Path $ilRepackOutPath -ItemType Directory -ErrorAction Stop | Out-Null

Write-Host ">_ Run ILRepack"

$command = "$ILRepackExePath /out:`"$mergedAssemblyPath`" `"$assemblyPath`" $itemsToMergeString"
Write-Host ">_ Command: `"$command`""
Invoke-Expression -Command $command


if ($LASTEXITCODE -ne 0) {
    Write-Host ">_ Error invoking merge"
    exit 1
} 

Write-Host ">_ Remove merged"
foreach ($item in $itemsToMerge) {
    Write-Host "- Remove $($item.FullName)"
    Remove-Item -Path $item.FullName -Force
}

Write-Host ">_ Replace target"
foreach ($item in Get-ChildItem -Path $ilRepackOutPath -File) {
    Write-Host "- Move $($item.FullName) to $BuildOutputDir"
    Move-Item -Force -Path $item.FullName -Destination $BuildOutputDir
}

Write-Host ">_ Done"
exit 0

