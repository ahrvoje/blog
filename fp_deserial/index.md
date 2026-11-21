---
title: Floating Point deserialization
date: 2026-11-21
author: Hrvoje Abraham
---

A decimal string has one correct double: the nearest one, with ties to even. In 2016 I tested how Mathematica reads such strings, and no method was correct for all inputs. This post shows the 2016 results and the same test repeated in 2026.

Two independent routes read all test strings correctly from Wolfram: the C function `strtod` of the Windows C runtime, and `Double.Parse` of current .NET. Of the routes A to Y in this post, 22 fail on the first input below.

The first route is `strtod`, loaded into the kernel, with a check that it read the whole string. The second input is not a number, and the route rejects it. The third is the short form of infinity.

```
c = "RawPointer"::["UnsignedInteger8"]; end = RawMemoryAllocate[c];
strtod = ForeignFunctionLoad["C:\\Windows\\System32\\ucrtbase.dll",
  "strtod", {c, "RawPointer"::[c]} -> "CDouble"];
read[s_] := Module[{p = RawMemoryExport[s], x}, x = strtod[p, end];
  If[s != "" && RawMemoryRead@RawMemoryRead@end == 0, x, $Failed]]
read /@ {"2.4703282292062328e-324", "1.0e", "inf"}
(* {5.*^-324, $Failed, Inf} *)
```

The second route is current .NET through NETLink. Without the option, NETLink loads the old .NET Framework, which is not correct. `Needs` must stand on its own line, or the option has no effect. The invariant culture is necessary for `infinity`. The style permits a sign, a decimal point and an exponent, and nothing more; with the default style, .NET reads `1,5` as 15.

```
Needs["NETLink`"]
InstallNET[UseNETFramework -> False];
LoadNETType /@ {"System.Double", "System.Globalization.CultureInfo"};
(* AllowLeadingSign + AllowDecimalPoint + AllowExponent *)
parseStyle = 4 + 32 + 128;
Double`Parse[#, parseStyle, CultureInfo`InvariantCulture] & /@
  {"2.4703282292062328e-324", "infinity", "inf", "1,5"}
(* {5.*^-324, Infinity, $Failed, $Failed} *)
```

.NET does not accept `inf`. IEEE 754-2008 (clause 5.12.1) names both `inf` and `infinity`, in any letter case, so .NET deviates from the standard at this point. Its numbers are correct.

## The test

Twenty strings from the hard regions: underflow, subnormal numbers, halfway cases and overflow. A method passes a test when its result, taken exactly, is equal to the correct double. Where infinity is correct, each form of infinity passes. Two forms occurred: the symbol `Infinity`, and the IEEE infinity as a machine number, which Wolfram prints as `Inf`.

| ID | Input string | Correct double | Exact value |
|---:|:---|:---|:---|
| 1 | `1e-400` | `0x0000000000000000` | $0$ |
| 2 | `2.4703282292062326e-324` | `0x0000000000000000` | $0$ |
| 3 | `2.4703282292062327e-324` | `0x0000000000000000` | $0$ |
| 4 | `2.4703282292062328e-324` | `0x0000000000000001` | $2^{-1074}$ |
| 5 | `4.9406564584124654e-324` | `0x0000000000000001` | $2^{-1074}$ |
| 6 | `1e-320` | `0x00000000000007e8` | $2024 \cdot 2^{-1074}$ |
| 7 | `2.2250738585072009e-308` | `0x000fffffffffffff` | $4503599627370495 \cdot 2^{-1074}$ |
| 8 | `2.2250738585072014e-308` | `0x0010000000000000` | $4503599627370496 \cdot 2^{-1074}$ |
| 9 | `1.e-25` | `0x3abef2d0f5da7dd9` | $8711228593176025 \cdot 2^{-136}$ |
| 10 | `1.0e-23` | `0x3b282db34012b251` | $6805647338418769 \cdot 2^{-129}$ |
| 11 | `1.2345678901234567890` | `0x3ff3c0ca428c59fb` | $5559999489923579 \cdot 2^{-52}$ |
| 12 | `1.13e1` | `0x402699999999999a` | $6361334473660826 \cdot 2^{-49}$ |
| 13 | `1e+19` | `0x43e158e460913d00` | $4882812500000000 \cdot 2^{11}$ |
| 14 | `1.9e+22` | `0x449017f7df96be18` | $4529953002929688 \cdot 2^{22}$ |
| 15 | `2.7e22` | `0x4496deb1154f79ec` | $6437301635742188 \cdot 2^{22}$ |
| 16 | `3.1e22` | `0x449a420db02bd7d6` | $7390975952148438 \cdot 2^{22}$ |
| 17 | `7e22` | `0x44ada56a4b0835c0` | $8344650268554688 \cdot 2^{23}$ |
| 18 | `1.7976931348623158e+308` | `0x7fefffffffffffff` | $9007199254740991 \cdot 2^{971}$ |
| 19 | `1.7976931348623159e+308` | `0x7ff0000000000000` | $\infty$ |
| 20 | `1e+400` | `0x7ff0000000000000` | $\infty$ |

## The methods

Eleven ways to read the string `s`, as written in 2016. Fifteen more follow in the 2026 section. Method E is `System.Double.Parse` of .NET, called through NETLink. Method D has a 2016 form and a 2026 form, because ``Internal`StringToDouble`` does not exist in Wolfram 15.

```
A   N@ToExpression@StringReplace[s, "e" | "E" -> "*10^"]
B   N@ToExpression@StringReplace[s, "e" | "E" -> "*^"]
C   (N@# &)[Read[#, Number], Close@#] &@StringToStream@s
D   Internal`StringToDouble@s        (2016)
    Internal`StringToMReal@s         (2026)
E   Double`Parse@s
F   N@ImportString[s, "JSON"]
G   N@Interpreter["Number"][s]
H   N@First@ImportString[s, "List"]
I   N@ImportString[s, "CSV"][[1, 1]]
J   N@ImportString[s, "Table"][[1, 1]]
K   First@ImportString[ExportString[N@First@ImportString[s, "List"], "Real64"], "Real64"]
```

## 2016

*Mathematica 10.4 on Windows, 24 April 2016.*

| Method | Failed tests | Count |
|:---|:---|---:|
| A | 1, 2, 3, 4, 5, 6, 9, 10, 12, 14, 19, 20 | 12 |
| B | 1, 2, 3, 4, 6, 19, 20 | 7 |
| C | 1, 2, 3, 4, 5, 6, 19, 20 | 8 |
| D | 1, 2, 3, 4, 5, 6, 7, 11, 19, 20 | 10 |
| E | 2, 3, 19, 20 | 4 |
| F | 4, 9, 14, 15, 16, 17, 19, 20 | 8 |
| G | 1, 2, 3, 4, 6, 9, 10, 12, 14, 19, 20 | 11 |
| H | 1, 2, 3, 4, 6, 19, 20 | 7 |
| I | 1, 2, 3, 4, 6, 19, 20 | 7 |
| J | 1, 2, 3, 4, 6, 19, 20 | 7 |
| K | 4, 5, 7 | 3 |

Every method fails. The plain text routes (B, H, I, J) fail only at the limits: underflow and overflow. Methods A and G also round ordinary values wrongly, such as `1.13e1`. The best one, the binary round trip K, still fails three subnormal tests.

For this reason I wrote [StringToDouble.wl](StringToDouble.wl) in 2016. It does the conversion in exact rational arithmetic: slow, but correct.

## 2026

*Wolfram 15.0.1 on Windows, 21 November 2026. NETLink loads .NET Framework 4.8.*

| Method | Failed tests | Count, 2016 → 2026 |
|:---|:---|---:|
| A | 4, 5, 9, 10, 12, 14, 19, 20 | 12 → 8 |
| B | 4, 19, 20 | 7 → 3 |
| C | 4, 19, 20 | 8 → 3 |
| D | 1, 2, 3, 4, 5, 6, 7, 11, 19, 20 | 10 → 10 |
| E | 2, 3, 19, 20 | 4 → 4 |
| F | 4, 19, 20 | 8 → 3 |
| G | 4, 5, 12, 14, 19, 20 | 11 → 6 |
| H | 4, 19, 20 | 7 → 3 |
| I | 19, 20 | 7 → 2 |
| J | 4, 19, 20 | 7 → 3 |
| K | 4, 5 | 3 → 2 |

Underflow is repaired: tests 1, 2, 3 and 6 now pass in the text routes. Three failures stay. Test 4 gives zero where the smallest subnormal is correct. Tests 19 and 20 give an arbitrary-precision number, or `Missing` in method I, where infinity is correct. These failures are real, not an effect of the infinity form: the kernel does not overflow, it leaves the machine numbers and returns a finite number that no double can hold, such as `1.7976931348623159*^308`. Methods A and G still round `1.13e1` and `1.9e+22` wrongly.

The new form of method D fails the same ten tests as the old form did in 2016. .NET Framework 4.8 fails the same four tests as in 2016.

The rule compares values only. For tests 6, 7, 19 and 20, method K now returns the correct value, but not as a machine double.

### Routes added in 2026

Fifteen more routes, L to Z, with three helpers. `mark` writes a precision mark into the string. `rational` builds the exact rational value of the string. `atof` loads the C function `atof` from a Windows system library. Method Z uses `read` from the introduction.

```
mark[s_, p_] := If[StringContainsQ[s, "e" | "E"], StringReplace[s, "e" | "E" -> p <> "*^"], s <> p]
rational[s_] := Module[{m, e, d},
  {m, e} = StringSplit[If[StringFreeQ[s, "e" | "E"], s <> "e0", s], "e" | "E"];
  d = If[StringFreeQ[m, "."], 0, StringLength[m] - First@First@StringPosition[m, "."]];
  ToExpression[StringDelete[m, "."]]*10^(ToExpression[e] - d)]
atof[lib_] := ForeignFunctionLoad[FileNameJoin[{Environment["SystemRoot"], "System32", lib}],
  "atof", {"RawPointer"::["UnsignedInteger8"]} -> "CDouble"]

L   ToExpression@mark[s, "`"]
M   N@ToExpression@mark[s, "`2000"]
N   (N@# &)[Read[#, Real], Close@#] &@StringToStream@s
O   N@First@ReadList[StringToStream@s, Real]
P   N@ImportString[s, "RawJSON"]
Q   N@ImportString[s, "ExpressionJSON"]
R   N@Developer`ReadRawJSONString@s
S   N@ImportString[s, "TSV"][[1, 1]]
T   N@ImportString[s, "YAML"]
U   N@Interpreter["Real"][s]
V   N@First@SemanticImportString[s, "Number", "List"]
W   N@rational@s
X   N@N[rational@s, 40]
Y   atof["msvcrt.dll"]@RawMemoryExport@s
Z   read@s
```

| Method | Failed tests | Count |
|:---|:---|---:|
| L | 4, 19, 20 | 3 |
| M | 4, 19, 20 | 3 |
| N | 4, 19, 20 | 3 |
| O | 4, 19, 20 | 3 |
| P | 4, 19, 20 | 3 |
| Q | 4, 19, 20 | 3 |
| R | 4, 19, 20 | 3 |
| S | 19, 20 | 2 |
| T | 1, 2, 3, 4, 5, 6, 7, 11, 19, 20 | 10 |
| U | 4, 5, 12, 14, 19, 20 | 6 |
| V | 4, 5, 12, 14, 19, 20 | 6 |
| W | 4, 8, 9, 10, 19, 20 | 6 |
| X | 4, 19, 20 | 3 |
| Y | 4, 14, 15, 16, 17 | 5 |
| Z | none | 0 |

Eight of the new routes fail tests 4, 19 and 20, the same as B, C, F, H and J. This points to one number parser in the kernel. YAML import (T) fails the same tests as D. `Interpreter["Real"]` and `SemanticImportString` (U, V) fail the same tests as G.

Method W shows a second defect: `N` of an exact rational is not correctly rounded. `N[1/10^25]` gives `9.999999999999999e-26`. A step through 40 digits (X) repairs these cases, but not tests 4, 19 and 20.

Method Z, the last one, passes all twenty tests. It is `strtod` of `ucrtbase.dll`, the Universal C Runtime of Windows, here version 10.0.26100. The old runtime `msvcrt.dll` (Y) fails five. Y and Z are the only routes that return the machine `Inf` for tests 19 and 20. Method K and current .NET return the symbol `Infinity`.

Both runtimes are part of Windows today. The Universal C Runtime came with Visual C++ 2015 and is the one for new programs. `msvcrt.dll` stays, unchanged, for old ones. So the parser that a program gets depends on how the program was built, not on the Windows version. Nine libraries in `System32` export `strtod`: the four UCRT builds pass all tests, and the five older runtimes fail the same five as Y.

### The larger collection

My test collection [strtod_tests.toml](https://github.com/ahrvoje/Resources/blob/main/numerics/strtod/strtod_tests.toml) holds 81 conversion tests, 35 formatting tests and 22 strings that a reader must reject. `StringToDouble.wl` passes all of them.

Method Z reads the 81 conversion tests bit for bit and rejects all 22 bad strings. The whole-string check is necessary for that: by the C standard, `strtod` converts the longest valid start of a string, so `1.0e` alone gives 1. Two differences stay, both in NaN. Its payload is not the one of the collection, and `nan(type-0)` is rejected, because C does not permit a hyphen there. Outside the collection, `strtod` also accepts leading white space and hexadecimal numbers such as `0x1p3`.

### Current .NET and the exact routine

Wolfram 15 can also load current .NET. `InstallNET[UseNETFramework -> False]` starts NETLink on the lowest installed version from 6 up, here .NET 7.0. With the environment variable `DOTNET_ROLL_FORWARD=LatestMajor` it starts on the highest one, here .NET 9.0. .NET 10 is not installed for all programs on this computer, so I tested it through PowerShell 7. Use the newest version: .NET 7.0 gives zero for one 774-character string of the larger collection (test C79), where .NET 9.0 and 10.0 are correct.

| Route | Failed tests | Count |
|:---|:---|---:|
| E through NETLink on .NET 7.0 and on .NET 9.0 | none | 0 |
| `double.Parse` on .NET 10.0, in PowerShell 7 | none | 0 |
| `StringToDouble.wl`, version 3 of June 2016 | none | 0 |

Current .NET reads all twenty strings correctly, also when Wolfram calls it.

### Three correct readers

Method Z, current .NET and `StringToDouble.wl` are independent code. With .NET 9.0 or 10.0, they agree bit for bit on the twenty tests and on the 81 conversion tests of the collection. They differ in the text that they accept. The .NET column is for the invariant culture and the default parse style.

| Input | Z, UCRT `strtod` | .NET 10 `double.Parse` | `StringToDouble.wl` |
|:---|:---|:---|:---|
| the 22 bad strings | rejected | rejected | rejected |
| `inf`, `-inf`, `+INF` | infinity | rejected | infinity |
| `infinity`, `Infinity` | infinity | infinity | infinity |
| `nan` | NaN | NaN, sign bit set | NaN |
| `+nan(catch_22)`, `-nan()` | NaN | rejected | NaN |
| `nan(type-0)` | rejected | rejected | NaN |
| `1,5` | rejected | 15 | rejected |
| `" 1.5"` | 1.5 | 1.5 | rejected |
| `"1.5 "` | rejected | 1.5 | rejected |
| `0x1p3` | 8 | rejected | rejected |

For numbers the three readers can replace each other. For infinity, NaN and the decision what is valid text, they cannot.

Two results of .NET depend on the culture. The first is infinity. A culture has one text for it, and `double.Parse` accepts only that text, in any letter case. The 890 cultures of .NET 10 have these texts:

| Text for infinity | Cultures | Examples |
|:---|---:|:---|
| `∞` | 886 | `en-US`, `hr-HR` |
| the Dzongkha word | 2 | `dz`, `dz-BT` |
| `INF` | 1 | `en-US-POSIX` |
| `Infinity` | 1 | the invariant culture |

So no culture accepts both `inf` and `infinity`.

The second is the comma. .NET reads the comma in `1,5` as a digit group mark and returns 15. A culture rejects `1,5` only if its decimal mark is the point and its group mark is not the comma. Of the 465 cultures with a decimal point, 42 are of this kind:

| Group mark | Cultures | Examples |
|:---|---:|:---|
| apostrophe `’` | 10 | `de-CH`, `de-LI`, `en-CH`, `it-CH`, `rm` |
| no-break space | 17 | `tn`, `xh`, `nso`, `mfe` |
| other marks | 15 | `ff-Adlm`, `nqo` |

A culture is not necessary for this. `double.Parse` also takes a parse style, and a stricter style than the default rejects the comma. With the invariant culture:

| Input | Default style | `NumberStyles.Float` | Sign, point and exponent only |
|:---|:---|:---|:---|
| `1.5` | 1.5 | 1.5 | 1.5 |
| `1,5` | 15 | rejected | rejected |
| `1,000.5` | 1000.5 | rejected | rejected |
| `" 1.5"` | 1.5 | 1.5 | rejected |
| `"1.5 "` | 1.5 | 1.5 | rejected |
| `-1.5e3` | −1500 | −1500 | −1500 |
| `infinity` | infinity | infinity | infinity |
| `nan` | NaN | NaN | NaN |

The last style is `AllowLeadingSign`, `AllowDecimalPoint` and `AllowExponent`, the one of the example in the introduction. With it, .NET and `StringToDouble.wl` accept the same numbers of the collection. Only infinity and NaN stay different.

A parse style is a sum of flags. .NET 10 has eleven, and the style of the example sets three of them:

| Flag | Value | Example style | Permits |
|:---|---:|:---|:---|
| `AllowLeadingWhite` | 1 | <span class="off">off</span> | white space before the number |
| `AllowTrailingWhite` | 2 | <span class="off">off</span> | white space after the number |
| `AllowLeadingSign` | 4 | <span class="on">on</span> | a sign before the number |
| `AllowTrailingSign` | 8 | <span class="off">off</span> | a sign after the number, as in `5-` |
| `AllowParentheses` | 16 | <span class="off">off</span> | `(5)` for −5 |
| `AllowDecimalPoint` | 32 | <span class="on">on</span> | the decimal point |
| `AllowThousands` | 64 | <span class="off">off</span> | digit group marks, as in `1,000` |
| `AllowExponent` | 128 | <span class="on">on</span> | an exponent, as in `1e5` |
| `AllowCurrencySymbol` | 256 | <span class="off">off</span> | a currency sign |
| `AllowHexSpecifier` | 512 | <span class="off">off</span> | hexadecimal digits |
| `AllowBinarySpecifier` | 1024 | <span class="off">off</span> | binary digits |

The default style is 231: the three flags of the example, the two for white space, and `AllowThousands`. `NumberStyles.Float` is 167, the default without `AllowThousands`.

## Conclusion

In ten years Wolfram repaired underflow, but no route through the kernel parser reads all twenty strings correctly. The best ones, CSV and TSV import, still fail at overflow: they give `Missing`, which is not a form of infinity. Correct results come from outside the kernel: the C runtime of Windows, current .NET, or an exact routine such as `StringToDouble.wl`.

## Data and code

- [tests.json](tests.json): the twenty tests.
- [results2016.json](results2016.json): failed tests of 2016, from the original notebook.
- [run2026.wls](run2026.wls) and [results2026.json](results2026.json): the 2026 run and its results.
- [run2026_collection.wls](run2026_collection.wls) and [collection.json](collection.json): the larger collection against `StringToDouble.wl` and method Z.
- [run2026_dotnet.wls](run2026_dotnet.wls): method E through NETLink on current .NET.
- [collection_dotnet.ps1](collection_dotnet.ps1): the larger collection against `double.Parse`.
- [cultures_dotnet.ps1](cultures_dotnet.ps1): the cultures of .NET, their text for infinity, their group marks, and the parse styles.
- [net.ps1](net.ps1): the `double.Parse` test. PowerShell 7 runs it on .NET 10, Windows PowerShell on .NET Framework 4.8.
- [StringToDouble.wl](StringToDouble.wl): the exact conversion routine.
