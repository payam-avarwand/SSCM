#define MyAppName "SSCM"
#define MyAppVersion "1.0"
#define MyAppPublisher "payam-avarwand"
#define MyAppURL "https://github.com/payam-avarwand"
#define MyAppExeName "0.ps1"
#define MyAppIcon "SSCM.ico"
#define MyVbsLauncher "SSCM_Launcher.vbs"

[Setup]
AppId={{SSCM.com.yahoo@Avar_Pavar}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\Avarwand\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\icons\{#MyAppIcon}
OutputDir=C:\temp
OutputBaseFilename=SSCM-{#MyAppVersion}-Setup
SetupIconFile=C:\temp\SSCM.ico
SolidCompression=yes
WizardStyle=modern
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesInstallIn64BitMode=x64

; Added fields
VersionInfoCopyright=©Avarwand

 
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"


[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\temp\0.ps1"; DestDir: "{app}"; Flags: ignoreversion deleteafterinstall
; Icon is no longer deleted after install AND is moved to a cleaner location
Source: "C:\temp\SSCM.ico"; DestDir: "{app}\icons"; Flags: ignoreversion


[Icons]
; Use the VBS launcher with the updated icon path
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyVbsLauncher}"; IconFilename: "{app}\icons\{#MyAppIcon}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyVbsLauncher}"; Tasks: desktopicon; IconFilename: "{app}\icons\{#MyAppIcon}"


[Run]
Filename: "{app}\{#MyVbsLauncher}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  VbsContent: string;
  VbsPath: string;
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Create the VBS launcher script
    VbsPath := ExpandConstant('{app}\{#MyVbsLauncher}');
    VbsContent := 
      'On Error Resume Next' + #13#10 +
      'Set fso = CreateObject("Scripting.FileSystemObject")' + #13#10 +
      'Set shell = CreateObject("WScript.Shell")' + #13#10 +
      'appPath = fso.GetParentFolderName(WScript.ScriptFullName)' + #13#10 +
      'psScript = appPath & "\{#MyAppExeName}"' + #13#10 +
      'If fso.FileExists(psScript) Then' + #13#10 +
      '  shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & psScript & """", 0, False' + #13#10 +
      'Else' + #13#10 +
      '  MsgBox "PowerShell script not found: " & psScript, vbCritical, "Error"' + #13#10 +
      'End If';
    
    SaveStringToFile(VbsPath, VbsContent, False);

    // Hide the PowerShell script and make it read-only/system
    Exec('cmd.exe', '/C attrib +h +r +s "' + ExpandConstant('{app}\{#MyAppExeName}') + '"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

    // Protect all files in the icons folder
    Exec('cmd.exe', '/C attrib +h +r +s "' + ExpandConstant('{app}\icons\*.*') + '" /S', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Protect the icons folder itself
    Exec('cmd.exe', '/C attrib +h +r +s "' + ExpandConstant('{app}\icons') + '"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

    // Check if VBS file was created
    if not FileExists(VbsPath) then
      MsgBox('Failed to create VBS launcher at: ' + VbsPath, mbError, MB_OK);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  AppDir: string;
  ResultCode: Integer;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    AppDir := ExpandConstant('{app}');
    
    // Remove hidden/read-only/system attributes from files first (optional but recommended)
    if FileExists(AppDir + '\{#MyAppExeName}') then
      Exec('cmd.exe', '/C attrib -h -r -s "' + AppDir + '\{#MyAppExeName}"', '', 
           SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Force delete the entire directory and all contents
    if DirExists(AppDir) then
    begin
      Exec('cmd.exe', '/C rmdir /s /q "' + AppDir + '"', '', 
           SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;