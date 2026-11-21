# The cultures of .NET: the text for infinity, and the cultures that reject "1,5".
# Run with PowerShell 7 for current .NET.
$inv = [Globalization.CultureInfo]::InvariantCulture
$all = [Globalization.CultureInfo]::GetCultures('AllCultures')
function Read-Double($s, $c) { try { [double]::Parse($s, $c).ToString('R', $inv) } catch { 'rejected' } }
$codes = { param($t) ($t.ToCharArray() | ForEach-Object { '{0:x4}' -f [int]$_ }) -join ' ' }

[System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
"cultures: $($all.Count)"

'text for infinity (character codes), number of cultures, examples:'
$all | Group-Object { $_.NumberFormat.PositiveInfinitySymbol } | Sort-Object Count -Descending | ForEach-Object {
  '  [{0}]  {1,4}  {2}' -f (& $codes $_.Name), $_.Count, (($_.Group | Select-Object -First 4 | ForEach-Object { if ($_.Name) { $_.Name } else { 'invariant' } }) -join ' ') }

$point = $all | Where-Object { $_.NumberFormat.NumberDecimalSeparator -eq '.' }
$strict = $all | Where-Object { (Read-Double '1.5' $_) -eq '1.5' -and (Read-Double '1,5' $_) -eq 'rejected' }
"cultures with a decimal point: $($point.Count); of these, 1,5 is rejected in: $($strict.Count)"
'group mark (character codes), number of cultures, cultures:'
$strict | Group-Object { $_.NumberFormat.NumberGroupSeparator } | ForEach-Object {
  '  [{0}]  {1,3}  {2}' -f (& $codes $_.Name), $_.Count, (($_.Group | ForEach-Object Name) -join ' ') }

$float = [Globalization.NumberStyles]::Float
'invariant culture with NumberStyles.Float: 1.5 -> ' + $(try { [double]::Parse('1.5', $float, $inv) } catch { 'rejected' }) +
  '; 1,5 -> ' + $(try { [double]::Parse('1,5', $float, $inv) } catch { 'rejected' })

# parse styles, invariant culture
$styles = [ordered]@{
  'default'                 = [Globalization.NumberStyles]'Float, AllowThousands'
  'Float'                   = [Globalization.NumberStyles]::Float
  'sign, point, exponent'   = [Globalization.NumberStyles]'AllowLeadingSign, AllowDecimalPoint, AllowExponent'
}
'parse styles, invariant culture:'
foreach ($s in '1.5', '1,5', '1,000.5', ' 1.5', '1.5 ', '-1.5e3', 'infinity', 'nan') {
  '  [{0,-8}] {1}' -f $s, (($styles.GetEnumerator() | ForEach-Object { $st = $_.Value; $_.Key + ': ' + $(try { [double]::Parse($s, $st, $inv).ToString('R', $inv) } catch { 'rejected' }) }) -join ' | ')
}
'default style of double.Parse(string): Float, AllowThousands = ' + ([double]::Parse('1,5', $inv) -eq [double]::Parse('1,5', [Globalization.NumberStyles]'Float, AllowThousands', $inv))

# the flags of a parse style, and the ones that the style of the example (164) sets
'parse style flags:'
[Enum]::GetValues([Globalization.NumberStyles]) | Sort-Object { [int]$_ } | ForEach-Object {
  $v = [int]$_; if ($v -ne 0 -and ($v -band ($v - 1)) -eq 0) { '  {0,-22} {1,5}  {2}' -f $_, $v, $(if (164 -band $v) { 'on' } else { 'off' }) } }
'default style: ' + [int]([Globalization.NumberStyles]'Float, AllowThousands') + '; Float: ' + [int][Globalization.NumberStyles]::Float
'trailing sign and parentheses: ' + (('5-', '(5)', '-5') | ForEach-Object { "$_ -> " + $(try { [double]::Parse($_, [Globalization.NumberStyles]'AllowTrailingSign, AllowParentheses, AllowLeadingSign', $inv) } catch { 'rejected' }) }) -join '; '
