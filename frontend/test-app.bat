@echo off
echo Testing Lost and Found Application
echo ===================================
echo.
echo Note: Make sure the Java backend is running on http://localhost:8080/lost-and-found-jsp
echo.
echo 1. Testing Backend Connection...
curl -s http://localhost:8080/lost-and-found-jsp/reportLost
echo.
echo.
echo 2. Testing Frontend Access...
curl -s -I http://localhost:3000 | findstr "200"
if %errorlevel% equ 0 (
    echo ✓ Frontend is accessible at http://localhost:3000
) else (
    echo ✗ Frontend is not accessible at http://localhost:3000
)
echo.
echo 3. Testing Report Form Pages...
curl -s -I http://localhost:3000/ReportLost.html | findstr "200"
if %errorlevel% equ 0 (
    echo ✓ ReportLost.html is accessible
) else (
    echo ✗ ReportLost.html is not accessible
)
echo.
curl -s -I http://localhost:3000/ReportFound.html | findstr "200"
if %errorlevel% equ 0 (
    echo ✓ ReportFound.html is accessible
) else (
    echo ✗ ReportFound.html is not accessible
)
echo.
echo Test complete! Check the results above.