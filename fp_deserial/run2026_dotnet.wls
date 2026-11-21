(* Method E of the 2016 experiment, with NETLink on current .NET in place of
   .NET Framework. NETLink starts on the lowest installed version from 6 up.
   For the highest one, set the environment variable DOTNET_ROLL_FORWARD=LatestMajor.
   Run: wolframscript -file run2026_dotnet.wls *)
Needs["NETLink`"];
InstallNET[UseNETFramework -> False];
LoadNETType["System.Double"];
LoadNETType["System.Runtime.InteropServices.RuntimeInformation"];
tests = Import[FileNameJoin[{DirectoryName[$InputFileName], "tests.json"}], "RawJSON"];
fails = Select[tests,
    ! TrueQ[Quiet[SetPrecision[Quiet@Double`Parse[#[[2]]], Infinity] == ToExpression[#[[4]]]]] &][[All, 1]];
Print[$Version, " | NETLink: ", RuntimeInformation`FrameworkDescription, " | E fails: ", fails];
