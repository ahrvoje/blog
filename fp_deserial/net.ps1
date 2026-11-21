$tests = Get-Content -Raw (Join-Path $PSScriptRoot 'tests.json') | ConvertFrom-Json
$inv = [Globalization.CultureInfo]::InvariantCulture
$fw = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
$fails = @()
foreach ($t in $tests) {
  try { $bits = '0x{0:x16}' -f [BitConverter]::DoubleToInt64Bits([double]::Parse($t[1], [Globalization.NumberStyles]::Float, $inv)) }
  catch { $bits = $_.Exception.InnerException.GetType().Name }
  if ($bits -ne $t[2]) { $fails += "$($t[0]) -> $bits" }
}
"$fw | fails: $($fails -join '; ')"
