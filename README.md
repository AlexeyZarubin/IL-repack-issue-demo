# IL-repack-issue-demo

![image](https://github.com/AlexeyZarubin/IL-repack-issue-demo/assets/26878995/e65f6960-b7fe-407f-9890-7e0fc03f8b5d)

## Issue details

See error with using "Microsoft.Extensions.Logging.ILoggingBuilder" class that has "TypeForwardedTo" attribute.
It failed to load type after merge, use please a Debug config.
From exception, it looks like it fails with TargetInvokationException to determine class source assembly.
Also the warning appears:
WARNING: Method reference is used with definition return type / parameter

The following ticket was found:
https://github.com/gluck/il-repack/issues/359

Uses .Net 4.8

## Build steps

dotnet run --project IssueDemo

or simply start project from Visual Studio.