(* Repeat of the 2016 experiment: the same tests and pass rule.
   Run: wolframscript -file run2026.wls *)
dir = DirectoryName[$InputFileName];
Needs["NETLink`"];
LoadNETType["System.Double"];
LoadNETType["System.Runtime.InteropServices.RuntimeInformation"];
Get[FileNameJoin[{dir, "StringToDouble.wl"}]];

(* methods of 2016; only D is changed *)
StringToDoubleA[s_] := N@ToExpression@StringReplace[s, "e" | "E" -> "*10^"]
StringToDoubleB[s_] := N@ToExpression@StringReplace[s, "e" | "E" -> "*^"]
StringToDoubleC[s_] := (N@# &)[Read[#, Number], Close@#] &@StringToStream@s
(* 2016: Internal`StringToDouble@s. That function does not exist in Wolfram 15. *)
StringToDoubleD[s_] := Internal`StringToMReal@s
StringToDoubleE[s_] := Double`Parse@s
StringToDoubleF[s_] := N@ImportString[s, "JSON"]
StringToDoubleG[s_] := N@Interpreter["Number"][s]
StringToDoubleH[s_] := N@First@ImportString[s, "List"]
StringToDoubleI[s_] := N@ImportString[s, "CSV"][[1, 1]]
StringToDoubleJ[s_] := N@ImportString[s, "Table"][[1, 1]]
StringToDoubleK[s_] := First@ImportString[ExportString[N@First@ImportString[s, "List"], "Real64"], "Real64"]

(* helpers for the routes added in 2026 *)
mark[s_, p_] := If[StringContainsQ[s, "e" | "E"], StringReplace[s, "e" | "E" -> p <> "*^"], s <> p]
rational[s_] := Module[{m, e, d},
  {m, e} = StringSplit[If[StringFreeQ[s, "e" | "E"], s <> "e0", s], "e" | "E"];
  d = If[StringFreeQ[m, "."], 0, StringLength[m] - First@First@StringPosition[m, "."]];
  ToExpression[StringDelete[m, "."]]*10^(ToExpression[e] - d)]
atof[lib_] := ForeignFunctionLoad[FileNameJoin[{Environment["SystemRoot"], "System32", lib}], "atof",
  {"RawPointer"::["UnsignedInteger8"]} -> "CDouble"]
msvcrt = atof["msvcrt.dll"];
(* strtod of the Universal C Runtime, with a check that it read the whole string *)
c = "RawPointer"::["UnsignedInteger8"]; end = RawMemoryAllocate[c];
strtod = ForeignFunctionLoad[FileNameJoin[{Environment["SystemRoot"], "System32", "ucrtbase.dll"}],
  "strtod", {c, "RawPointer"::[c]} -> "CDouble"];
read[s_] := Module[{p = RawMemoryExport[s], x}, x = strtod[p, end];
  If[s != "" && RawMemoryRead@RawMemoryRead@end == 0, x, $Failed]]

methods = <|"A" -> StringToDoubleA, "B" -> StringToDoubleB, "C" -> StringToDoubleC, "D" -> StringToDoubleD,
   "E" -> StringToDoubleE, "F" -> StringToDoubleF, "G" -> StringToDoubleG, "H" -> StringToDoubleH,
   "I" -> StringToDoubleI, "J" -> StringToDoubleJ, "K" -> StringToDoubleK,
   (* routes added in 2026 *)
   "L" -> (ToExpression@mark[#, "`"] &),
   "M" -> (N@ToExpression@mark[#, "`2000"] &),
   "N" -> ((N@# &)[Read[#, Real], Close@#] &@StringToStream@# &),
   "O" -> (N@First@ReadList[StringToStream@#, Real] &),
   "P" -> (N@ImportString[#, "RawJSON"] &),
   "Q" -> (N@ImportString[#, "ExpressionJSON"] &),
   "R" -> (N@Developer`ReadRawJSONString@# &),
   "S" -> (N@ImportString[#, "TSV"][[1, 1]] &),
   "T" -> (N@ImportString[#, "YAML"] &),
   "U" -> (N@Interpreter["Real"][#] &),
   "V" -> (N@First@SemanticImportString[#, "Number", "List"] &),
   "W" -> (N@rational@# &),
   "X" -> (N@N[rational@#, 40] &),
   "Y" -> (msvcrt@RawMemoryExport@# &),
   "Z" -> read,
   "StringToDouble.wl" -> StringToDouble`StringToDouble|>;

(* {ID, input string, bits of the correct double, exact value} *)
tests = Import[FileNameJoin[{dir, "tests.json"}], "RawJSON"];

(* the rule of 2016: the result, taken exactly, is equal to the exact value.
   2026: where infinity is correct, each form of infinity is accepted:
   the symbol Infinity, and the IEEE infinity as a machine number, printed as Inf. *)
infinityQ[r_] := r === Infinity || ToString[r, InputForm] === "Inf"
run[m_] := Table[
   Module[{r = Quiet@TimeConstrained[m[t[[2]]], 40, $TimedOut]},
    <|"test" -> ToExpression[t[[1]]],
      "ok" -> If[t[[4]] === "Infinity", infinityQ[r], TrueQ[Quiet[SetPrecision[r, Infinity] == ToExpression[t[[4]]]]]],
      "machine" -> MachineNumberQ[r],
      "result" -> StringTake[ToString[r, InputForm], UpTo[60]]|>],
   {t, tests}];

results = run /@ methods;
Export[FileNameJoin[{dir, "results2026.json"}],
  <|"version" -> $Version, "netlink" -> RuntimeInformation`FrameworkDescription, "results" -> results|>, "JSON"];
Print[$Version, " | NETLink: ", RuntimeInformation`FrameworkDescription];
KeyValueMap[Print[#1, ": ", Select[#2, ! #ok &][[All, "test"]]] &, results];
