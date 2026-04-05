@echo off
echo Testing Lost and Found Application
echo ===================================
echo.
echo 1. Testing API Health...
curl -s http://localhost:8082/api/health
echo.
echo.
echo 2. Testing Lost Reports (should be empty)...
curl -s http://localhost:8082/api/lost-reports
echo.
echo.
echo 3. Testing Found Reports (should be empty)...
curl -s http://localhost:8082/api/found-reports
echo.
echo.
echo 4. Testing form accessibility...
curl -s -I http://localhost:8082/ReportLost.html | findstr "200"
if %errorlevel% equ 0 (
    echo ✓ ReportLost.html is accessible
) else (
    echo ✗ ReportLost.html is not accessible
)
echo.
curl -s -I http://localhost:8082/ReportFound.html | findstr "200"
if %errorlevel% equ 0 (
    echo ✓ ReportFound.html is accessible
) else (
    echo ✗ ReportFound.html is not accessible
)
echo.
echo Test complete! Check the results above.