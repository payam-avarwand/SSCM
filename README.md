# Self-Signed Certificate Manager
This PowerShell script provides a graphical user interface (GUI) to manage self-signed certificates on Windows machines.
It is designed to assist IT administrators or developers with common certificate-related tasks without requiring
command-line interaction.
It offers functions such as listing, searching and removing Self-signed Certificates.


## Features
- List Certificates:
> Displays installed self-signed certificates in a user-friendly GUI.
- Search Functionality:
> Allows filtering the certificate list using keywords to quickly locate specific entries.
- Remove Certificates:
> Enables secure deletion of selected self-signed certificates from the system.
- Provides the possibility to digitally sign files using selected certificates via a GUI-based process using the Microsoft Product SignTool.exe
> Supported file types to sign: .exe, .dll, .ocx, .sys, .scr, .msi, .msp, .cab, .cat, .inf
- Easy installation
- Licensed under EULA (see LICENSE.txt)



## License
This software is freeware and distributed under a custom [End User License Agreement](LICENSE.txt). Source code is not shared!


## Installer Download

To install the tool, download the latest `.exe` installer (zipped version) from the [Releases](https://github.com/payam-avarwand/SSCM/releases) section.

> **Note**: This installer is **self-signed**, still, Windows SmartScreen may warn you — this is expected for unsigned softwares.


## Author & Timeline:
- Author: Payam Avarwand
- Initial Release: April 21, 2025
- Last Update: May 6, 2025