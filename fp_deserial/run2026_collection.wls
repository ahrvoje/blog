(* The larger test collection against StringToDouble.wl and method Z (strtod of the Windows C runtime).
   collection.json is strtod_tests.toml of the Resources repository, as JSON:
   "conv" 81 conversion tests, "fmt" 35 formatting tests, "neg" 22 strings to reject.
   Run: wolframscript -file run2026_collection.wls *)
dir = DirectoryName[$InputFileName];
Get[FileNameJoin[{dir, "StringToDouble.wl"}]];
all = Import[FileNameJoin[{dir, "collection.json"}], "RawJSON"];

(* method Z: strtod, with a check that it read the whole string *)
c = "RawPointer"::["UnsignedInteger8"]; end = RawMemoryAllocate[c];
lib = FileNameJoin[{Environment["SystemRoot"], "System32", "ucrtbase.dll"}];
strtod = ForeignFunctionLoad[lib, "strtod", {c, "RawPointer"::[c]} -> "CDouble"];
read[s_] := Module[{p = RawMemoryExport[s], x}, x = strtod[p, end];
  If[s != "" && RawMemoryRead@RawMemoryRead@end == 0, x, $Failed]]

(* bits of the double that the C runtime reads, through _atodbl of the same library *)
atodbl = ForeignFunctionLoad[lib, "_atodbl", {"RawPointer"::["UnsignedInteger64"], c} -> "CInt"];
buf = RawMemoryAllocate["UnsignedInteger64"];
bits[s_] := Module[{p = RawMemoryExport[s]}, atodbl[buf, p]; IntegerString[RawMemoryRead[buf], 16, 16]];

nanQ[h_] := With[{b = FromDigits[h, 16]}, BitAnd[BitShiftRight[b, 52], 2047] == 2047 && BitAnd[b, 2^52 - 1] != 0];
sign[h_] := BitShiftRight[FromDigits[h, 16], 63];
invalid = "Invalid floating point string format.";

Do[
  Module[{ts = all[g]},
   Print[g, ": ", Length[ts], " tests"];
   Print["  StringToDouble.wl, wrong bits or exact value: ",
    Select[ts, Quiet@Catch[StringToDouble`StringToDoubleHex[#str]] =!= #hex ||
        Quiet@Catch[StringToDouble`StringToDoubleInt[#str]] =!= #int &][[All, "uid"]]];
   Print["  method Z, rejected: ", Select[ts, read[#str] === $Failed &][[All, "str"]]];
   Print["  method Z, wrong bits: ",
    Select[ts, bits[#str] =!= #hex && ! (nanQ[#hex] && nanQ[bits[#str]] && sign[#hex] == sign[bits[#str]]) &][[All, "uid"]]];
   Print["  method Z, NaN with a different payload: ", Select[ts, nanQ[#hex] && bits[#str] =!= #hex &][[All, "uid"]]]],
  {g, {"conv", "fmt"}}];

neg = all["neg"];
Print["neg: ", Length[neg], " strings to reject"];
Print["  StringToDouble.wl accepts: ", Select[neg, Quiet@Catch[StringToDouble`StringToDoubleHex[#]] =!= invalid &]];
Print["  method Z accepts: ", Select[neg, read[#] =!= $Failed &]];
