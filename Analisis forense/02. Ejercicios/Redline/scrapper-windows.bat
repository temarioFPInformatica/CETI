:: Set UTF-8 encoding
chcp 65001

@echo off 
:: Encable runtime variables
SETLOCAL EnableDelayedExpansion

:: Determine OS
call:determineArchitecture

:: Change Dir
SET MYPATH=%~dp0
SET LETTER=%MYPATH:~0,2%
!LETTER!
cd !MYPATH!

:: Generate Save path
call:exportDate false
set ZIP_PATH=%CD%\sessions
set ZIP_NAME=!STAMP!
set SAVE_PATH=%CD%\sessions\!STAMP!
if not exist "!SAVE_PATH!" mkdir "!SAVE_PATH!"

call:bannerCall

:: Start script date
call:startDateCall

:: IP configuration
call:ipconfigCall

:: DNS CACHE
call:displaydnsCall

:: ARP CACHE
call:arpcacheCall

:: Netstat open ports
call:netstatPortsCall

:: Netstat Applications with open ports
call:netstatApplicationsCall

:: Netstat Routing table
call:netstatRoutingTableCall

:: Netbios connections
call:netbiosConnectionsCall

:: URL Protocols from Nirsoft
call:nirsoftUrlProtocolsCall

:: Network units
call:netUseCall

:: Shared folders
call:netShareCall

:: Network copy CACHE
call:netFileCall

:: Sysinternals Recent opened files remotely
call::sysIntPsFileCall !OS!

:: Command history
call:doskeyCall

:: Task list
call:taskListCall

:: Sysinternals hierarchical tree of running processes
call::sysIntPsListCall !OS!

:: Sysinternals running processes with DLLs
call::sysIntListDllCall !OS!

:: Sysinternals handles opened
call::sysIntHandleCall !OS!

:: URL Protocols from Nirsoft
call:nirsoftCProcessCall

:: Running services
call:runningServicesCall

:: Users & groups from netbios
call:netbiosUserGroupsCall

:: Local users
call:usersCall

:: Users logged in
call:usersLoggedInCall

:: Sysinternals logged on sessions
call:sysIntLogonSessionsCall

:: Sysinternals loggen on users
call:sysIntPsLoggedOnCall

:: Nirsoft user & passwords from web browsers
call:nirsoftWebBrowserPassCall

:: Nirsoft user & passwords from network
call:nirsoftNetworkPassCall

:: Nirsoft user & passwords from mail clients
call:nirsoftMailPassCall

:: Nirsoft user & passwords from multiple forms saved as bullets
call:nirsoftBulletsPassCall

:: Last accessed files
call:dirAccessCall

:: Nirsoft browser last search
call::nirsoftLastSearchCall

:: Nirsoft browser history
call:nirsoftBrowserHistoryCall

:: End script date
call:endDateCall

:: Compress results
call:compressCall


echo Finished! Press any key to exit . . .
pause>nul

::--------------------------------------------------------
::-- Function Export Date
::--------------------------------------------------------
:exportDate
set d=%date:~6,4%-%date:~3,2%-%date:~0,2%
IF "%~1" == "true" (
	set t=%time::=:%
)
IF "%~1" == "false" (
	set t=%time::=.%
)
set t=!t: =0!
FOR /F "tokens=*" %%g IN ('tzutil /g') do (SET TimeZ=%%g)
IF "%~1" == "true" (
	set STAMP=!d! !t! !TimeZ!
)
IF "%~1" == "false" (
	set STAMP=!d!-!t!
)
goto:eof

:determineArchitecture
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
goto:eof

:startDateCall
call:exportDate true
echo !STAMP! > "!SAVE_PATH!\001-start-date.log"
certutil -hashfile "!SAVE_PATH!\001-start-date.log" SHA256 > "!SAVE_PATH!\001-start-date-hash.sha256"
certutil -hashfile "!SAVE_PATH!\001-start-date.log" SHA512 > "!SAVE_PATH!\001-start-date-hash.sha512"
goto:eof

:ipconfigCall
echo RESULT OF ipconfig /all > "!SAVE_PATH!\002-ipconfig.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\002-ipconfig.log"
echo -------------------------------------------- >> "!SAVE_PATH!\002-ipconfig.log"
ipconfig /all >> "!SAVE_PATH!\002-ipconfig.log"
certutil -hashfile "!SAVE_PATH!\002-ipconfig.log" SHA256 > "!SAVE_PATH!\002-ipconfig-hash.sha256"
certutil -hashfile "!SAVE_PATH!\002-ipconfig.log" SHA512 > "!SAVE_PATH!\002-ipconfig-hash.sha512"
goto:eof

:displaydnsCall
echo RESULT OF ipconfig /displaydns > "!SAVE_PATH!\003-dns-cache.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\003-dns-cache.log"
echo -------------------------------------------- >> "!SAVE_PATH!\003-dns-cache.log"
ipconfig /displaydns >> "!SAVE_PATH!\003-dns-cache.log"
certutil -hashfile "!SAVE_PATH!\003-dns-cache.log" SHA256 > "!SAVE_PATH!\003-dns-cache-hash.sha256"
certutil -hashfile "!SAVE_PATH!\003-dns-cache.log" SHA512 > "!SAVE_PATH!\003-dns-cache-hash.sha512"
goto:eof

:arpcacheCall
echo RESULT OF arp -a > "!SAVE_PATH!\004-arp-cache.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\004-arp-cache.log"
echo -------------------------------------------- >> "!SAVE_PATH!\004-arp-cache.log"
arp -a >> "!SAVE_PATH!\004-arp-cache.log"
certutil -hashfile "!SAVE_PATH!\004-arp-cache.log" SHA256 > "!SAVE_PATH!\004-arp-cache-hash.sha256"
certutil -hashfile "!SAVE_PATH!\004-arp-cache.log" SHA512 > "!SAVE_PATH!\004-arp-cache-hash.sha512"
goto:eof

:netstatPortsCall
echo RESULT OF netstat -an > "!SAVE_PATH!\005-netstat.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\005-netstat.log"
echo -------------------------------------------- >> "!SAVE_PATH!\005-netstat.log"
netstat -an | findstr /i "estado status listening established" >> "!SAVE_PATH!\005-netstat.log"
certutil -hashfile "!SAVE_PATH!\005-netstat.log" SHA256 > "!SAVE_PATH!\005-netstat-hash.sha256"
certutil -hashfile "!SAVE_PATH!\005-netstat.log" SHA512 > "!SAVE_PATH!\005-netstat-hash.sha512"
goto:eof

:netstatApplicationsCall
echo RESULT OF netstat -anob > "!SAVE_PATH!\006-netstat-apps.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\006-netstat-apps.log"
echo -------------------------------------------- >> "!SAVE_PATH!\006-netstat-apps.log"
netstat -anob >> "!SAVE_PATH!\006-netstat-apps.log"
certutil -hashfile "!SAVE_PATH!\006-netstat-apps.log" SHA256 > "!SAVE_PATH!\006-netstat-apps-hash.sha256"
certutil -hashfile "!SAVE_PATH!\006-netstat-apps.log" SHA512 > "!SAVE_PATH!\006-netstat-apps-hash.sha512"
goto:eof

:netstatRoutingTableCall
echo RESULT OF netstat -r > "!SAVE_PATH!\007-netstat-routing-table.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\007-netstat-routing-table.log"
echo -------------------------------------------- >> "!SAVE_PATH!\007-netstat-routing-table.log"
netstat -r >> "!SAVE_PATH!\007-netstat-routing-table.log"
certutil -hashfile "!SAVE_PATH!\007-netstat-routing-table.log" SHA256 > "!SAVE_PATH!\007-netstat-routing-table-hash.sha256"
certutil -hashfile "!SAVE_PATH!\007-netstat-routing-table.log" SHA512 > "!SAVE_PATH!\007-netstat-routing-table-hash.sha512"
goto:eof

:netbiosConnectionsCall
echo RESULT OF nbtstat -S > "!SAVE_PATH!\008-netbios-connections.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\008-netbios-connections.log"
echo -------------------------------------------- >> "!SAVE_PATH!\008-netbios-connections.log"
nbtstat -S >> "!SAVE_PATH!\008-netbios-connections.log"
certutil -hashfile "!SAVE_PATH!\008-netbios-connections.log" SHA256 > "!SAVE_PATH!\008-netbios-connections-hash.sha256"
certutil -hashfile "!SAVE_PATH!\008-netbios-connections.log" SHA512 > "!SAVE_PATH!\008-netbios-connections-hash.sha512"
goto:eof

:nirsoftUrlProtocolsCall
echo RESULT OF URLProtocolView > "!SAVE_PATH!\009-nirsoft-urlprotocols.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\009-nirsoft-urlprotocols.log"
echo -------------------------------------------- >> "!SAVE_PATH!\009-nirsoft-urlprotocols.log"
..\Windows-Nirsoft\system-tools\URLProtocolView /stext "!SAVE_PATH!\009-nirsoft-urlprotocols-tmp.log"
timeout 5 > NUL
type "!SAVE_PATH!\009-nirsoft-urlprotocols-tmp.log" >> "!SAVE_PATH!\009-nirsoft-urlprotocols.log"
del "!SAVE_PATH!\009-nirsoft-urlprotocols-tmp.log"
certutil -hashfile "!SAVE_PATH!\009-nirsoft-urlprotocols.log" SHA256 > "!SAVE_PATH!\009-nirsoft-urlprotocols-hash.sha256"
certutil -hashfile "!SAVE_PATH!\009-nirsoft-urlprotocols.log" SHA512 > "!SAVE_PATH!\009-nirsoft-urlprotocols-hash.sha512"
goto:eof

:netUseCall
echo RESULT OF net use > "!SAVE_PATH!\010-network-units.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\010-network-units.log"
echo -------------------------------------------- >> "!SAVE_PATH!\010-network-units.log"
net use >> "!SAVE_PATH!\010-network-units.log"
certutil -hashfile "!SAVE_PATH!\010-network-units.log" SHA256 > "!SAVE_PATH!\010-network-units-hash.sha256"
certutil -hashfile "!SAVE_PATH!\010-network-units.log" SHA512 > "!SAVE_PATH!\010-network-units-hash.sha512"
goto:eof

:netShareCall
echo RESULT OF net share > "!SAVE_PATH!\011-network-shared.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\011-network-shared.log"
echo -------------------------------------------- >> "!SAVE_PATH!\011-network-shared.log"
net share >> "!SAVE_PATH!\011-network-shared.log"
certutil -hashfile "!SAVE_PATH!\011-network-shared.log" SHA256 > "!SAVE_PATH!\011-network-shared-hash.sha256"
certutil -hashfile "!SAVE_PATH!\011-network-shared.log" SHA512 > "!SAVE_PATH!\011-network-shared-hash.sha512"
goto:eof

:netFileCall
echo RESULT OF net file > "!SAVE_PATH!\012-network-copy.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\012-network-copy.log"
echo -------------------------------------------- >> "!SAVE_PATH!\012-network-copy.log"
net file >> "!SAVE_PATH!\012-network-copy.log"
certutil -hashfile "!SAVE_PATH!\012-network-copy.log" SHA256 > "!SAVE_PATH!\012-network-copy-hash.sha256"
certutil -hashfile "!SAVE_PATH!\012-network-copy.log" SHA512 > "!SAVE_PATH!\012-network-copy-hash.sha512"
goto:eof

:sysIntPsFileCall
IF "%~1" == "32BIT" (
	echo RESULT OF psfile > "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	..\sysinternals\psfile /accepteula  >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
)
IF "%~1" == "64BIT" (
	echo RESULT OF psfile64 > "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
	..\sysinternals\psfile64 /accepteula  >> "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log"
)
certutil -hashfile "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log" SHA256 > "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely-hash.sha256"
certutil -hashfile "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely.log" SHA512 > "!SAVE_PATH!\013-sysinternals-recent-opened-files-remotely-hash.sha512"
goto:eof

:doskeyCall
echo RESULT OF tasklist > "!SAVE_PATH!\014-command-history.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\014-command-history.log"
echo -------------------------------------------- >> "!SAVE_PATH!\014-command-history.log"
doskey /history >> "!SAVE_PATH!\014-command-history.log"
certutil -hashfile "!SAVE_PATH!\014-command-history.log" SHA256 > "!SAVE_PATH!\014-command-history-hash.sha256"
certutil -hashfile "!SAVE_PATH!\014-command-history.log" SHA512 > "!SAVE_PATH!\014-command-history-hash.sha512"
goto:eof

:taskListCall
echo RESULT OF tasklist > "!SAVE_PATH!\015-task-list.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\015-task-list.log"
echo -------------------------------------------- >> "!SAVE_PATH!\015-task-list.log"
tasklist >> "!SAVE_PATH!\015-task-list.log"
certutil -hashfile "!SAVE_PATH!\015-task-list.log" SHA256 > "!SAVE_PATH!\015-task-list-hash.sha256"
certutil -hashfile "!SAVE_PATH!\015-task-list.log" SHA512 > "!SAVE_PATH!\015-task-list-hash.sha512"
goto:eof

:sysIntpsListCall
IF "%~1" == "32BIT" (
	echo RESULT OF pslist > "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	..\sysinternals\pslist /accepteula /t >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"

)
IF "%~1" == "64BIT" (
	echo RESULT OF pslist64 > "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
	..\sysinternals\pslist64 /accepteula /t >> "!SAVE_PATH!\016-sysinternals-running-processes-tree.log"
)
certutil -hashfile "!SAVE_PATH!\016-sysinternals-running-processes-tree.log" SHA256 > "!SAVE_PATH!\016-sysinternals-running-processes-tree-hash.sha256"
certutil -hashfile "!SAVE_PATH!\016-sysinternals-running-processes-tree.log" SHA512 > "!SAVE_PATH!\016-sysinternals-running-processes-tree-hash.sha512"
goto:eof

:sysIntListDllCall
IF "%~1" == "32BIT" (
	echo RESULT OF Listdlls > "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	..\sysinternals\Listdlls /accepteula >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
)
IF "%~1" == "64BIT" (
	echo RESULT OF Listdlls64 > "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
	..\sysinternals\Listdlls64 /accepteula >> "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log"
)
certutil -hashfile "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log" SHA256 > "!SAVE_PATH!\017-sysinternals-running-processes-dlls-hash.sha256"
certutil -hashfile "!SAVE_PATH!\017-sysinternals-running-processes-dlls.log" SHA512 > "!SAVE_PATH!\017-sysinternals-running-processes-dlls-hash.sha512"
goto:eof

:sysIntHandleCall
IF "%~1" == "32BIT" (
	echo RESULT OF handle > "!SAVE_PATH!\018-sysinternals-handles.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\018-sysinternals-handles.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\018-sysinternals-handles.log"
	..\sysinternals\handle /accepteula >> "!SAVE_PATH!\018-sysinternals-handles.log"
)
IF "%~1" == "64BIT" (
	echo RESULT OF handle64 > "!SAVE_PATH!\018-sysinternals-handles.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\018-sysinternals-handles.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\018-sysinternals-handles.log"
	..\sysinternals\handle64 /accepteula >> "!SAVE_PATH!\018-sysinternals-handles.log"
)
certutil -hashfile "!SAVE_PATH!\018-sysinternals-handles.log" SHA256 > "!SAVE_PATH!\018-sysinternals-handles-hash.sha256"
certutil -hashfile "!SAVE_PATH!\018-sysinternals-handles.log" SHA512 > "!SAVE_PATH!\018-sysinternals-handles-hash.sha512"
goto:eof

:nirsoftCProcessCall
echo RESULT OF CProcess > "!SAVE_PATH!\019-nirsoft-current-processes.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\019-nirsoft-current-processes.log"
echo -------------------------------------------- >> "!SAVE_PATH!\019-nirsoft-current-processes.log"
..\Windows-Nirsoft\system-tools\CProcess /stext "!SAVE_PATH!\019-nirsoft-current-processes-tmp.log"
timeout 5 > NUL
type "!SAVE_PATH!\019-nirsoft-current-processes-tmp.log" >> "!SAVE_PATH!\019-nirsoft-current-processes.log"
del "!SAVE_PATH!\019-nirsoft-current-processes-tmp.log"
certutil -hashfile "!SAVE_PATH!\019-nirsoft-current-processes.log" SHA256 > "!SAVE_PATH!\019-nirsoft-current-processes-hash.sha256"
certutil -hashfile "!SAVE_PATH!\019-nirsoft-current-processes.log" SHA512 > "!SAVE_PATH!\019-nirsoft-current-processes-hash.sha512"
goto:eof

:runningServicesCall
echo RESULT OF sc query > "!SAVE_PATH!\020-running-services.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\020-running-services.log"
echo -------------------------------------------- >> "!SAVE_PATH!\020-running-services.log"
sc query >> "!SAVE_PATH!\020-running-services.log"
certutil -hashfile "!SAVE_PATH!\020-running-services.log" SHA256 > "!SAVE_PATH!\020-running-services-hash.sha256"
certutil -hashfile "!SAVE_PATH!\020-running-services.log" SHA512 > "!SAVE_PATH!\020-running-services-hash.sha512"
goto:eof

:netbiosUserGroupsCall
echo RESULT OF nbtstat -n > "!SAVE_PATH!\021-netbios-users-groups.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\021-netbios-users-groups.log"
echo -------------------------------------------- >> "!SAVE_PATH!\021-netbios-users-groups.log"
nbtstat -n >> "!SAVE_PATH!\021-netbios-users-groups.log"
certutil -hashfile "!SAVE_PATH!\021-netbios-users-groups.log" SHA256 > "!SAVE_PATH!\021-netbios-users-groups-hash.sha256"
certutil -hashfile "!SAVE_PATH!\021-netbios-users-groups.log" SHA512 > "!SAVE_PATH!\021-netbios-users-groups-hash.sha512"
goto:eof

:usersCall
echo RESULT OF net user > "!SAVE_PATH!\022-local-users.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\022-local-users.log"
echo -------------------------------------------- >> "!SAVE_PATH!\022-local-users.log"
net user >> "!SAVE_PATH!\022-local-users.log"
certutil -hashfile "!SAVE_PATH!\022-local-users.log" SHA256 > "!SAVE_PATH!\022-local-users-hash.sha256"
certutil -hashfile "!SAVE_PATH!\022-local-users.log" SHA512 > "!SAVE_PATH!\022-local-users-hash.sha512"
goto:eof

:usersLoggedInCall
echo RESULT OF net session > "!SAVE_PATH!\023-users-logged-in.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\023-users-logged-in.log"
echo -------------------------------------------- >> "!SAVE_PATH!\023-users-logged-in.log"
net session >> "!SAVE_PATH!\023-users-logged-in.log"
certutil -hashfile "!SAVE_PATH!\023-users-logged-in.log" SHA256 > "!SAVE_PATH!\023-users-logged-in-hash.sha256"
certutil -hashfile "!SAVE_PATH!\023-users-logged-in.log" SHA512 > "!SAVE_PATH!\023-users-logged-in-hash.sha512"
goto:eof

:sysIntLogonSessionsCall
IF "%~1" == "32BIT" (
	echo RESULT OF logonsessions > "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	..\sysinternals\logonsessions /accepteula >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
)
IF "%~1" == "64BIT" (
	echo RESULT OF logonsessions64 > "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
	..\sysinternals\logonsessions64 /accepteula >> "!SAVE_PATH!\024-sysinternals-logonsessions.log"
)
certutil -hashfile "!SAVE_PATH!\024-sysinternals-logonsessions.log" SHA256 > "!SAVE_PATH!\024-sysinternals-logonsessions-hash.sha256"
certutil -hashfile "!SAVE_PATH!\024-sysinternals-logonsessions.log" SHA512 > "!SAVE_PATH!\024-sysinternals-logonsessions-hash.sha512"
goto:eof

:sysIntPsLoggedOnCall
IF "%~1" == "32BIT" (
	echo RESULT OF PsLoggedon > "!SAVE_PATH!\025-sysinternals-logged-users.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
	..\sysinternals\PsLoggedon /accepteula >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
)
IF "%~1" == "64BIT" (
	echo RESULT OF PsLoggedon64 > "!SAVE_PATH!\025-sysinternals-logged-users.log"
	call:exportDate true
	echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
	echo -------------------------------------------- >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
	..\sysinternals\PsLoggedon64 /accepteula >> "!SAVE_PATH!\025-sysinternals-logged-users.log"
)
certutil -hashfile "!SAVE_PATH!\025-sysinternals-logged-users.log" SHA256 > !SAVE_PATH!\025-sysinternals-logged-users-hash.sha256"
certutil -hashfile "!SAVE_PATH!\025-sysinternals-logged-users.log" SHA512 > !SAVE_PATH!\025-sysinternals-logged-users-hash.sha512"
goto:eof

:nirsoftWebBrowserPassCall
echo RESULT OF WebBrowserPassView > "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log"
echo -------------------------------------------- >> "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log"
echo Please, save the file as !SAVE_PATH!\026-nirsoft-web-browser-passwords-tmp.log
..\Windows-Nirsoft\password-tools\WebBrowserPassView  /stab "!SAVE_PATH!\026-nirsoft-web-browser-passwords-tmp.log"
pause>nul
type "!SAVE_PATH!\026-nirsoft-web-browser-passwords-tmp.log" >> "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log"
del "!SAVE_PATH!\026-nirsoft-web-browser-passwords-tmp.log"
certutil -hashfile "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log" SHA256 > "!SAVE_PATH!\026-nirsoft-web-browser-passwords-hash.sha256"
certutil -hashfile "!SAVE_PATH!\026-nirsoft-web-browser-passwords.log" SHA512 > "!SAVE_PATH!\026-nirsoft-web-browser-passwords-hash.sha512"
goto:eof

:nirsoftNetworkPassCall
echo RESULT OF netpass > "!SAVE_PATH!\027-nirsoft-network-passwords.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\027-nirsoft-network-passwords.log"
echo -------------------------------------------- >> "!SAVE_PATH!\027-nirsoft-network-passwords.log"
echo Please, save the file as !SAVE_PATH!\027-nirsoft-network-passwords-tmp.log
..\Windows-Nirsoft\password-tools\netpass /stab "!SAVE_PATH!\027-nirsoft-network-passwords-tmp.log"
pause>nul
type "!SAVE_PATH!\027-nirsoft-network-passwords-tmp.log" >> "!SAVE_PATH!\027-nirsoft-network-passwords.log"
del "!SAVE_PATH!\027-nirsoft-network-passwords-tmp.log"
certutil -hashfile "!SAVE_PATH!\027-nirsoft-network-passwords.log" SHA256 > "!SAVE_PATH!\027-nirsoft-network-passwords-hash.sha256"
certutil -hashfile "!SAVE_PATH!\027-nirsoft-network-passwords.log" SHA512 > "!SAVE_PATH!\027-nirsoft-network-passwords-hash.sha512"
goto:eof

:nirsoftMailPassCall
echo RESULT OF mailpv > "!SAVE_PATH!\028-nirsoft-mail-passwords.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\028-nirsoft-mail-passwords.log"
echo -------------------------------------------- >> "!SAVE_PATH!\028-nirsoft-mail-passwords.log"
..\Windows-Nirsoft\password-tools\mailpv /stab "!SAVE_PATH!\028-nirsoft-mail-passwords-tmp.log"
echo Please, save the file as !SAVE_PATH!\028-nirsoft-mail-passwords-tmp.log
pause>nul
type "!SAVE_PATH!\028-nirsoft-mail-passwords-tmp.log" >> "!SAVE_PATH!\028-nirsoft-mail-passwords.log"
del "!SAVE_PATH!\028-nirsoft-mail-passwords-tmp.log"
certutil -hashfile "!SAVE_PATH!\028-nirsoft-mail-passwords.log" SHA256 > "!SAVE_PATH!\028-nirsoft-mail-passwords-hash.sha256"
certutil -hashfile "!SAVE_PATH!\028-nirsoft-mail-passwords.log" SHA512 > "!SAVE_PATH!\028-nirsoft-mail-passwords-hash.sha512"
goto:eof

:nirsoftBulletsPassCall
echo RESULT OF BulletsPassView > "!SAVE_PATH!\029-nirsoft-bullets-passwords.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\029-nirsoft-bullets-passwords.log"
echo -------------------------------------------- >> "!SAVE_PATH!\029-nirsoft-bullets-passwords.log"
..\Windows-Nirsoft\password-tools\BulletsPassView /stab "!SAVE_PATH!\029-nirsoft-bullets-passwords-tmp.log"
timeout 15 > NUL
type "!SAVE_PATH!\029-nirsoft-bullets-passwords-tmp.log" >> "!SAVE_PATH!\029-nirsoft-bullets-passwords.log"
del "!SAVE_PATH!\029-nirsoft-bullets-passwords-tmp.log"
certutil -hashfile "!SAVE_PATH!\029-nirsoft-bullets-passwords.log" SHA256 > "!SAVE_PATH!\029-nirsoft-bullets-passwords-hash.sha256"
certutil -hashfile "!SAVE_PATH!\029-nirsoft-bullets-passwords.log" SHA512 > "!SAVE_PATH!\029-nirsoft-bullets-passwords-hash.sha512"
goto:eof

:dirAccessCall
echo RESULT OF dir /t:a /a /s /o:d /4 c:\ > "!SAVE_PATH!\030-last-accessed-files.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\030-last-accessed-files.log"
echo -------------------------------------------- >> "!SAVE_PATH!\030-last-accessed-files.log"
nbtstat -n >> "!SAVE_PATH!\030-last-accessed-files.log"
certutil -hashfile "!SAVE_PATH!\030-last-accessed-files.log" SHA256 > "!SAVE_PATH!\030-last-accessed-files-hash.sha256"
certutil -hashfile "!SAVE_PATH!\030-last-accessed-files.log" SHA512 > "!SAVE_PATH!\030-last-accessed-files-hash.sha512"
goto:eof

:nirsoftLastSearchCall
echo RESULT OF MyLastSearch > "!SAVE_PATH!\031-nirsoft-browser-last-search.log"
call:exportDate true
echo TIMESTAMP: !STAMP! >> "!SAVE_PATH!\031-nirsoft-browser-last-search.log"
echo -------------------------------------------- >> "!SAVE_PATH!\031-nirsoft-browser-last-search.log"
..\Windows-Nirsoft\browser-tools\MyLastSearch /stext "!SAVE_PATH!\031-nirsoft-browser-last-search-tmp.log"
timeout 15 > NUL
type "!SAVE_PATH!\031-nirsoft-browser-last-search-tmp.log" >> "!SAVE_PATH!\031-nirsoft-browser-last-search.log"
del "!SAVE_PATH!\031-nirsoft-browser-last-search-tmp.log"
certutil -hashfile "!SAVE_PATH!\031-nirsoft-browser-last-search.log" SHA256 > "!SAVE_PATH!\031-nirsoft-browser-last-search-hash.sha256"
certutil -hashfile "!SAVE_PATH!\031-nirsoft-browser-last-search.log" SHA512 > "!SAVE_PATH!\031-nirsoft-browser-last-search-hash.sha512"
goto:eof

:nirsoftBrowserHistoryCall
..\Windows-Nirsoft\browser-tools\BrowsingHistoryView /VisitTimeFilterType 1 /HistorySource 2 /scomma "!SAVE_PATH!\032-nirsoft-browser-history.csv"
timeout 25 > NUL
certutil -hashfile "!SAVE_PATH!\032-nirsoft-browser-history.csv" SHA256 > "!SAVE_PATH!\032-nirsoft-browser-history-hash.sha256"
certutil -hashfile "!SAVE_PATH!\032-nirsoft-browser-history.csv" SHA512 > "!SAVE_PATH!\032-nirsoft-browser-history-hash.sha512"
goto:eof

:endDateCall
call:exportDate true
echo !STAMP! > "!SAVE_PATH!\033-end-date.log"
certutil -hashfile "!SAVE_PATH!\033-end-date.log" SHA256 > "!SAVE_PATH!\033-end-date-hash.sha256"
certutil -hashfile "!SAVE_PATH!\033-end-date.log" SHA512 > "!SAVE_PATH!\033-end-date-hash.sha512"
goto:eof

:compressCall
..\7zip\7za a -tzip !ZIP_PATH!\!ZIP_NAME!.zip !SAVE_PATH!
certutil -hashfile !ZIP_PATH!\!ZIP_NAME!.zip SHA256 > "!ZIP_PATH!\!ZIP_NAME!-hash.sha256"
certutil -hashfile !ZIP_PATH!\!ZIP_NAME!.zip SHA512 > "!ZIP_PATH!\!ZIP_NAME!-hash.sha512"
goto:eof

:bannerCall
cls
echo ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗
echo ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝
echo ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗
echo ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║
echo ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║
echo  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝
echo     ███████╗ ██████╗██████╗  █████╗ ██████╗ ██████╗ ███████╗██████╗ 
echo     ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
echo     ███████╗██║     ██████╔╝███████║██████╔╝██████╔╝█████╗  ██████╔╝
echo     ╚════██║██║     ██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗
echo     ███████║╚██████╗██║  ██║██║  ██║██║     ██║     ███████╗██║  ██║
echo     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝
echo By José Antonio Yáñez Jiménez
timeout 5 > NUL
goto:eof                                                                
