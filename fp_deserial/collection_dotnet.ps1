# The larger test collection (collection.json) against double.Parse.
# PowerShell 7 runs it on current .NET, Windows PowerShell on .NET Framework 4.8.
$all = Get-Content -Raw (Join-Path $PSScriptRoot 'collection.json') | ConvertFrom-Json
$inv = [Globalization.CultureInfo]::InvariantCulture
function Bits($s) { try { '{0:x16}' -f [BitConverter]::DoubleToInt64Bits([double]::Parse($s, $inv)) } catch { 'rejected' } }
[System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
foreach ($g in 'conv','fmt') {
  $bad = @(); foreach ($t in $all.$g) { $b = Bits $t.str; if ($b -ne $t.hex) { $bad += ('{0} "{1}" -> {2} (want {3})' -f $t.uid, $t.str.Substring(0, [Math]::Min(18, $t.str.Length)), $b, $t.hex) } }
  "$g ($($all.$g.Count)): differ: $($bad.Count)"; $bad | ForEach-Object { "   $_" }
}
$acc = @(); foreach ($s in $all.neg) { $b = Bits $s; if ($b -ne 'rejected') { $acc += "`"$s`" -> $b" } }
"neg ($($all.neg.Count)): accepted: $($acc -join '; ')"
'extra: ' + ((' 1.5','1.5 ','0x1p3','1,5','1.0e','1_000' | ForEach-Object { "`"$_`" -> $(Bits $_)" }) -join '; ')
