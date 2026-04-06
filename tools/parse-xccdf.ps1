param(
    [string]$InputPath,
    [string]$InboxRoot = (Join-Path $PSScriptRoot '..\scans\inbox'),
    [string]$OutputRoot = (Join-Path $PSScriptRoot '..\data\generated')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-LatestXmlFile {
    param([string]$Root)
    if (-not (Test-Path -LiteralPath $Root)) {
        throw "Inbox path not found: $Root"
    }

    $file = Get-ChildItem -LiteralPath $Root -Recurse -File -Filter *.xml |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $file) {
        throw "No XML files found under $Root"
    }

    return $file.FullName
}

function Get-NodeText {
    param([System.Xml.XmlNode]$Node, [string]$XPath)
    $match = $Node.SelectSingleNode($XPath)
    if ($null -eq $match) { return $null }
    if ($null -eq $match.InnerText) { return '' }
    return $match.InnerText.Trim()
}

function Get-FirstVId {
    param([System.Xml.XmlNode]$RuleNode)

    $groupNode = $RuleNode.SelectSingleNode("ancestor::*[local-name()='Group'][1]")
    if ($groupNode -and $groupNode.Attributes['id'] -and $groupNode.Attributes['id'].Value -match 'V-\d+') {
        return $Matches[0]
    }

    $identNodes = $RuleNode.SelectNodes(".//*[local-name()='ident']")
    foreach ($ident in $identNodes) {
        if ($ident.InnerText -match 'V-\d+') {
            return $Matches[0]
        }
    }

    $desc = $RuleNode.InnerText
    if ($desc -match 'V-\d+') {
        return $Matches[0]
    }

    return $null
}

function Normalize-ResultStatus {
    param([string]$Value)
    $normalized = if ($null -eq $Value) { 'unknown' } else { $Value.Trim().ToLowerInvariant() }
    switch ($normalized) {
        'pass' { 'pass' }
        'fail' { 'fail' }
        'error' { 'error' }
        'unknown' { 'unknown' }
        'notapplicable' { 'notapplicable' }
        'notchecked' { 'notchecked' }
        'notselected' { 'notselected' }
        'informational' { 'informational' }
        default { $normalized }
    }
}

function Build-JavaScriptArray {
    param(
        [string]$VariableName,
        [object]$Value
    )

    $json = ConvertTo-Json -InputObject $Value -Depth 8
    return "window.$VariableName = $json;"
}

function Get-ResultKey {
    param([object]$Result)
    if ($Result.control_id) { return [string]$Result.control_id }
    if ($Result.rule_id) { return [string]$Result.rule_id }
    return $null
}

function Compare-ScanResults {
    param(
        [object[]]$CurrentResults,
        [object[]]$PreviousResults
    )

    $previousIndex = @{}
    foreach ($prev in @($PreviousResults)) {
        $key = Get-ResultKey -Result $prev
        if (-not $key) { continue }
        $previousIndex[$key] = $prev
    }

    $regressed = @()
    $fixed = @()
    $newFail = @()
    $unchanged = @()

    foreach ($curr in @($CurrentResults)) {
        $key = Get-ResultKey -Result $curr
        if (-not $key) { continue }

        $prev = $null
        if ($previousIndex.ContainsKey($key)) {
            $prev = $previousIndex[$key]
        }

        $prevStatus = if ($prev) { [string]$prev.status } else { $null }
        $currStatus = [string]$curr.status

        $entry = [pscustomobject]@{
            control_id       = $curr.control_id
            rule_id          = $curr.rule_id
            title            = $curr.title
            previous_status  = $prevStatus
            current_status   = $currStatus
        }

        if ($prevStatus -eq 'pass' -and $currStatus -eq 'fail') {
            $regressed += $entry
        } elseif ($prevStatus -eq 'fail' -and $currStatus -eq 'pass') {
            $fixed += $entry
        } elseif (($null -eq $prevStatus -or $prevStatus -ne 'fail') -and $currStatus -eq 'fail') {
            $newFail += $entry
        } else {
            $unchanged += $entry
        }
    }

    return [pscustomobject]@{
        regressed = @($regressed)
        fixed = @($fixed)
        new_fail = @($newFail)
        unchanged = @($unchanged)
    }
}

if (-not $InputPath) {
    $InputPath = Get-LatestXmlFile -Root $InboxRoot
}

$resolvedInput = Resolve-Path -LiteralPath $InputPath
[xml]$xml = Get-Content -LiteralPath $resolvedInput -Raw

$benchmark = $xml.SelectSingleNode("//*[local-name()='Benchmark']")
$testResult = $xml.SelectSingleNode("//*[local-name()='TestResult']")

if ($null -eq $benchmark -or $null -eq $testResult) {
    throw "Input file does not look like an XCCDF result document: $resolvedInput"
}

$benchmarkTitle = Get-NodeText -Node $benchmark -XPath "./*[local-name()='title']"
$benchmarkVersion = Get-NodeText -Node $benchmark -XPath "./*[local-name()='version']"
$deviceName = Get-NodeText -Node $testResult -XPath "./*[local-name()='target']"
$scanTimestamp = if ($testResult.Attributes['end-time']) { $testResult.Attributes['end-time'].Value } elseif ($testResult.Attributes['start-time']) { $testResult.Attributes['start-time'].Value } else { $null }

$scanIdDate = if ($scanTimestamp) {
    try { (Get-Date $scanTimestamp).ToString('yyyy-MM-dd') } catch { (Get-Date).ToString('yyyy-MM-dd') }
} else {
    (Get-Date).ToString('yyyy-MM-dd')
}

$deviceId = if ($deviceName) { ($deviceName.ToLowerInvariant() -replace '[^a-z0-9]+', '-') } else { 'unknown-device' }
$scanId = "$deviceId-win11-$scanIdDate"

$ruleResults = @()
foreach ($node in $testResult.SelectNodes("./*[local-name()='rule-result']")) {
    $ruleRef = $node.Attributes['idref'].Value
    if (-not $ruleRef) { continue }

    $ruleNode = $benchmark.SelectSingleNode(".//*[local-name()='Rule' and @id='$ruleRef']")
    if ($null -eq $ruleNode) { continue }

    $controlId = Get-FirstVId -RuleNode $ruleNode
    $ruleId = Get-NodeText -Node $ruleNode -XPath "./*[local-name()='version']"
    $title = Get-NodeText -Node $ruleNode -XPath "./*[local-name()='title']"
    $severity = if ($ruleNode.Attributes['severity']) { $ruleNode.Attributes['severity'].Value } else { $null }
    $status = Normalize-ResultStatus -Value (Get-NodeText -Node $node -XPath "./*[local-name()='result']")

    $ruleResults += [pscustomobject]@{
        control_id = $controlId
        rule_id    = $ruleId
        status     = $status
        severity   = $severity
        title      = $title
    }
}

$normalized = @(
    [pscustomobject]@{
        scan_id           = $scanId
        device_id         = $deviceId
        device_name       = $deviceName
        benchmark         = $benchmarkTitle
        benchmark_version = $benchmarkVersion
        scan_timestamp    = $scanTimestamp
        source_file       = [string]$resolvedInput
        results           = $ruleResults
    }
)

$failedControls = @($ruleResults |
    Where-Object { $_.status -eq 'fail' } |
    ForEach-Object {
        [pscustomobject]@{
            VId      = $_.control_id
            RuleId   = $_.rule_id
            Severity = $_.severity
            Title    = $_.title
        }
    })

$scanDir = Join-Path $OutputRoot 'scans'
$latestJsonPath = Join-Path $OutputRoot 'latest-scan-results.json'
$latestJsPath = Join-Path $OutputRoot 'latest-baseline-data.js'
$latestFailedJsonPath = Join-Path $OutputRoot 'latest-baseline-failed.json'
$latestDeltaJsonPath = Join-Path $OutputRoot 'latest-scan-delta.json'
$scanJsonPath = Join-Path $scanDir "$scanId.json"

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
New-Item -ItemType Directory -Force -Path $scanDir | Out-Null

$previousScan = $null
$priorScanFiles = Get-ChildItem -LiteralPath $scanDir -File -Filter *.json -ErrorAction SilentlyContinue |
    Where-Object { $_.BaseName -ne $scanId } |
    Sort-Object LastWriteTime -Descending

foreach ($candidate in $priorScanFiles) {
    try {
        $parsedCandidate = Get-Content -LiteralPath $candidate.FullName -Raw | ConvertFrom-Json
        if ($parsedCandidate.device_id -eq $deviceId -and $parsedCandidate.benchmark -eq $benchmarkTitle) {
            $previousScan = $parsedCandidate
            break
        }
    } catch {
        continue
    }
}

$delta = [pscustomobject]@{
    scan_id = $scanId
    device_id = $deviceId
    benchmark = $benchmarkTitle
    previous_scan_id = if ($previousScan) { $previousScan.scan_id } else { $null }
    summary = [pscustomobject]@{
        regressed = 0
        fixed = 0
        new_fail = 0
        unchanged = $ruleResults.Count
    }
    regressed = @()
    fixed = @()
    new_fail = @()
    unchanged = @()
}

if ($previousScan) {
    $compared = Compare-ScanResults -CurrentResults $ruleResults -PreviousResults @($previousScan.results)
    $delta.summary.regressed = @($compared.regressed).Count
    $delta.summary.fixed = @($compared.fixed).Count
    $delta.summary.new_fail = @($compared.new_fail).Count
    $delta.summary.unchanged = @($compared.unchanged).Count
    $delta.regressed = @($compared.regressed)
    $delta.fixed = @($compared.fixed)
    $delta.new_fail = @($compared.new_fail)
    $delta.unchanged = @($compared.unchanged)
}

(ConvertTo-Json -InputObject @($normalized) -Depth 8) | Set-Content -LiteralPath $latestJsonPath -Encoding UTF8
(ConvertTo-Json -InputObject @($normalized) -Depth 8) | Set-Content -LiteralPath $scanJsonPath -Encoding UTF8
(ConvertTo-Json -InputObject @($failedControls) -Depth 6) | Set-Content -LiteralPath $latestFailedJsonPath -Encoding UTF8
(ConvertTo-Json -InputObject $delta -Depth 8) | Set-Content -LiteralPath $latestDeltaJsonPath -Encoding UTF8

$js = @(
    (Build-JavaScriptArray -VariableName 'GENERATED_SCAN_RESULTS' -Value @($normalized)),
    (Build-JavaScriptArray -VariableName 'GENERATED_BASELINE_FAILED' -Value @($failedControls)),
    (Build-JavaScriptArray -VariableName 'GENERATED_SCAN_DELTA' -Value $delta)
) -join "`r`n"
Set-Content -LiteralPath $latestJsPath -Value $js -Encoding UTF8

Write-Host "Parsed XCCDF result:"
Write-Host "  Input: $resolvedInput"
Write-Host "  Scan ID: $scanId"
Write-Host "  Failed controls: $($failedControls.Count)"
if ($previousScan) {
    Write-Host "  Previous scan: $($previousScan.scan_id)"
    Write-Host "  Regressed: $($delta.summary.regressed) | Fixed: $($delta.summary.fixed) | New fail: $($delta.summary.new_fail)"
} else {
    Write-Host "  Previous scan: none"
}
Write-Host "  Output JSON: $latestJsonPath"
Write-Host "  Output JS: $latestJsPath"
