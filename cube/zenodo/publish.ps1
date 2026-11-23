# Publishes the paper on Zenodo and puts the DOI into the paper and the blog post.
#   pwsh publish.ps1                      # token from $env:ZENODO_TOKEN
#   pwsh publish.ps1 -TokenVariable NAME  # token from another variable
# Steps: draft (reserves the DOI) -> DOI into paper.tex -> new PDF -> upload ->
# metadata -> publish -> DOI into ../index.md -> site build.
# A draft made by an earlier run is used again (deposition.json), so a second run
# does not make a second record. Each network call and each build has a time limit.
param([string]$TokenVariable = "ZENODO_TOKEN", [string]$License = "cc-by-4.0")
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$token = [Environment]::GetEnvironmentVariable($TokenVariable)
if (-not $token) { throw "The variable $TokenVariable is empty in this process." }
$api = "https://zenodo.org/api/deposit/depositions"
$auth = @{ Authorization = "Bearer $token" }
function Invoke-Zenodo($method, $uri, $body) {
    $a = @{ Method = $method; Uri = $uri; Headers = $auth; TimeoutSec = 120 }
    if ($null -ne $body) { $a.Body = ($body | ConvertTo-Json -Depth 8); $a.ContentType = "application/json" }
    Invoke-RestMethod @a
}

# 1. draft
if (Test-Path deposition.json) {
    $id = (Get-Content deposition.json -Raw | ConvertFrom-Json).id
    $dep = Invoke-Zenodo GET "$api/$id" $null
} else {
    $dep = Invoke-Zenodo POST $api @{}
    @{ id = $dep.id } | ConvertTo-Json | Set-Content deposition.json
}
if ($dep.submitted) { throw "Deposition $($dep.id) is already published." }
$doi = $dep.metadata.prereserve_doi.doi
if ($doi -notmatch '^10\.\d+/zenodo\.\d+$') { throw "No reserved DOI in the answer." }
"Draft $($dep.id), DOI $doi"

# 2. DOI into the paper, new PDF
$tex = Get-Content paper.tex -Raw
$tex = [regex]::Replace($tex, '\\newcommand\{\\doiline\}\{[^}]*\}', { "\newcommand{\doiline}{DOI: $doi}" })
if (-not $tex.Contains("DOI: $doi")) { throw "The DOI line is not in paper.tex." }
Set-Content paper.tex $tex -NoNewline -Encoding utf8
foreach ($pass in 1, 2) {
    $p = Start-Process pdflatex -ArgumentList "-interaction=nonstopmode", "-halt-on-error", "paper.tex" -NoNewWindow -PassThru -RedirectStandardOutput build.log -RedirectStandardError build.err
    if (-not $p.WaitForExit(300000)) { $p.Kill(); throw "pdflatex passed its time limit." }
    if ($p.ExitCode -ne 0) { throw "pdflatex failed, see build.log." }
}
Move-Item paper.pdf cube_capacitance.pdf -Force
Remove-Item build.log, build.err, paper.aux, paper.log -ErrorAction SilentlyContinue
Copy-Item ..\shells.jl, ..\patches.jl . -Force

# 3. upload (a file with the same name is replaced)
foreach ($f in "cube_capacitance.pdf", "paper.tex", "shells.jl", "patches.jl") {
    Invoke-RestMethod -Method PUT -Uri "$($dep.links.bucket)/$f" -Headers $auth -InFile $f -ContentType "application/octet-stream" -TimeoutSec 300 | Out-Null
    "Uploaded $f"
}

# 4. metadata
$meta = @{ metadata = @{
    title            = "The Capacitance of a Cube"
    upload_type      = "publication"
    publication_type = "preprint"
    publication_date = "2026-11-23"
    creators         = @(@{ name = "Abraham, Hrvoje" }, @{ name = "Fable 5.2"; affiliation = "Language model of Anthropic" })
    description      = "<p>The electrostatic capacitance of a metal cube has no known closed form. This paper gives two results. The first is an infinite series of positive terms for the capacitance, made of uniformly charged spherical shells. Each term is an algebraic number that follows from a closed formula and a recursion, with no integral. The series is exact, but too slow to give many decimals. The second is a fast series of the same structure, made of polynomial charge patches on the faces, graded toward the edges. All its integrals reduce to the error function. It gives the capacitance of a cube of side s as 4&pi;&epsilon;<sub>0</sub>s&kappa; with &kappa; = 0.660678154099568000 &plusmn; 10<sup>-18</sup>. The error is an estimate from the observed convergence, not a proved bound.</p><p>Files: the paper, its LaTeX source, and the two Julia programs that make all tables.</p>"
    access_right     = "open"
    license          = $License
    keywords         = @("capacitance", "cube", "variational method", "method of moments", "boundary elements", "Cholesky factorization")
    related_identifiers = @(@{ identifier = "https://github.com/ahrvoje/blog/tree/main/cube"; relation = "isSupplementedBy" })
    prereserve_doi   = $true
} }
Invoke-Zenodo PUT "$api/$($dep.id)" $meta | Out-Null
"Metadata set"

# 5. publish
$pub = Invoke-Zenodo POST "$api/$($dep.id)/actions/publish" $null
if ($pub.doi -ne $doi) { throw "Published DOI $($pub.doi) differs from the reserved DOI $doi." }
"Published: https://doi.org/$doi"

# 6. DOI into the blog post, site build
$md = Get-Content ..\index.md -Raw
if (-not $md.Contains($doi)) {
    $md = $md.TrimEnd() + "`n`nThis post is also a paper, with the programs, on Zenodo: [doi:$doi](https://doi.org/$doi).`n"
    Set-Content ..\index.md $md -NoNewline -Encoding utf8
}
Push-Location ..\..
$p = Start-Process npm.cmd -ArgumentList "run", "build" -NoNewWindow -PassThru
if (-not $p.WaitForExit(120000)) { $p.Kill(); throw "The site build passed its time limit." }
Pop-Location
"Done. DOI: $doi"
