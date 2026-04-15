
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Lost and Found Reporting</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #eef2f7; color: #1f2a37; }
            .container { max-width: 680px; margin: 28px auto; padding: 16px; }
            .hero { background: #fff; border-radius: 14px; padding: 26px; box-shadow: 0 3px 10px rgba(0,0,0,.08); text-align: center; }
            h1 { margin: 0 0 10px; }
            p { margin: 0 0 18px; color: #526170; }
            .actions { margin-top: 10px; display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
            .btn { text-decoration: none; background: #0d6efd; color: #fff; border-radius: 8px; padding: 11px 16px; display: inline-block; min-width: 200px; text-align: center; }
            .btn.secondary { background: #198754; }
            .cookie-banner { position: fixed; left: 16px; right: 16px; bottom: 16px; background: #fff; border: 1px solid #d8e1eb; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,.12); padding: 14px; display: none; z-index: 999; }
            .cookie-banner p { margin: 0 0 10px; font-size: .95rem; color: #2f3e4c; }
            .cookie-actions { display: flex; gap: 10px; flex-wrap: wrap; }
            .cookie-btn { border: none; border-radius: 8px; padding: 10px 14px; cursor: pointer; font: inherit; }
            .cookie-btn.accept { background: #198754; color: #fff; }
            .cookie-btn.decline { background: #f1f3f5; color: #1f2a37; }
            @media (max-width: 700px) { .btn { width: 100%; min-width: 0; } }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="hero">
                <h1>Welcome to Lost and Found System </h1>
                <p>Select one option to continue.</p>
                <div class="actions">
                    <a class="btn" href="report?type=LOST">Report Lost Item</a>
                    <a class="btn secondary" href="report?type=FOUND">Report Found Item</a>
                </div>
            </div>
        </div>
        <div id="cookieBanner" class="cookie-banner" role="dialog" aria-live="polite" aria-label="Cookie consent">
            <p>This site uses cookies to improve your experience. Do you accept cookies?</p>
            <div class="cookie-actions">
                <button id="acceptCookies" class="cookie-btn accept" type="button">Accept</button>
                <button id="declineCookies" class="cookie-btn decline" type="button">Decline</button>
            </div>
        </div>
        <script>
            (function () {
                const key = "cookieConsentChoice";
                const banner = document.getElementById("cookieBanner");
                const acceptBtn = document.getElementById("acceptCookies");
                const declineBtn = document.getElementById("declineCookies");
                const existingChoice = sessionStorage.getItem(key);

                if (!existingChoice) {
                    banner.style.display = "block";
                }

                function saveChoice(choice) {
                    sessionStorage.setItem(key, choice);
                    banner.style.display = "none";
                }

                acceptBtn.addEventListener("click", function () {
                    saveChoice("accepted");
                });

                declineBtn.addEventListener("click", function () {
                    saveChoice("declined");
                });
            })();
        </script>
    </body>
</html>
