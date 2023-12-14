@echo off

netsh interface ipv4 set address name=%interface% source=static addr=%ip% mask=%subnet% gateway=%gateway%

echo Interfaces List:
echo.
echo 1. LAN
echo 2. WLAN
echo.
set /p option=Option [1/2]: 

IF %option%==1 (
for /f "tokens=1-2 delims=:" %%a in ('netsh lan show interface ^|find "Name"') do set interface=%%b
)

IF %option%==2 (
for /f "tokens=1-2 delims=:" %%a in ('netsh wlan show interface ^|find "Name"') do set interface=%%b
)

set interface=%interface:~1%

netsh interface ipv4 set address name=%interface% source=dhcp

timeout /t 5 /nobreak

set /p secIP=Input Secondary IP: 
echo.
echo.
echo Please wait...

for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set ip=%%b
set ip=%ip:~1%

for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "Subnet"') do set subnet=%%b
set subnet=%subnet:~1%

for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "Default"') do set gateway=%%b
set gateway=%gateway:~1%

set dns1=1.1.1.1
set dns2=1.0.0.1

netsh interface ipv4 set address name=%interface% source=static addr=%ip% mask=%subnet% gateway=%gateway%
netsh interface ipv4 add address name=%interface% addr=%secIP% mask=%subnet%

netsh interface ip add dns name=%interface% addr=%dns1%
netsh interface ip add dns name=%interface% addr=%dns2% index=2


echo Interface	: %interface%
echo Primary IP	: %ip%
echo Secondary IP	: %secIP%
echo Subnetmask	: %subnet%
echo Gateway		: %gateway%
echo Primary DNS	: %dns1%
echo Secondary DNS	: %dns2%
echo.
echo.
echo Setup IP Address, Subnetmask, Gateway and DNS done.

pause