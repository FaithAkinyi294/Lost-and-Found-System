
<%@page import="beans.ReportBean, java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Lost and Found System</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            .nav {
                background: #fff;
                border-bottom: 1px solid #e4e7ec;
                padding: 12px 0;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            .nav .container {
                max-width: 900px;
                margin: 0 auto;
                padding: 0 16px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .nav .logo {
                font-weight: bold;
                font-size: 1.2rem;
                color: #1d2939;
            }
            .nav .menu {
                display: flex;
                gap: 20px;
            }
            .nav a {
                color: #475467;
                text-decoration: none;
                font-weight: 500;
            }
            .nav a:hover {
                color: #1d2939;
            }
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #facc15;
                color: #111827;
            }
            .wrapper {
                max-width: 900px;
                margin: 0 auto;
                padding: 36px 16px;
            }
            .hero {
                background: #ffffff;
                border-radius: 14px;
                box-shadow: 0 4px 14px rgba(15, 23, 42, 0.08);
                padding: 34px 24px;
                text-align: center;
            }
            .hero h1 {
                margin: 0;
                font-size: 2rem;
            }
            .hero p {
                margin: 12px auto 0;
                color: #475467;
                max-width: 640px;
                line-height: 1.5;
            }
            .grid {
                margin-top: 26px;
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
            }
            .card {
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e4e7ec;
                padding: 18px;
                text-align: left;
            }
            .card h2 {
                margin: 0 0 8px;
                font-size: 1.2rem;
            }
            .card p {
                margin: 0 0 12px;
                color: #667085;
            }
            .btn {
                display: inline-block;
                text-decoration: none;
                font-weight: 700;
                border-radius: 8px;
                padding: 10px 14px;
                color: #fff;
            }
            .btn.lost { background: #0d6efd; }
            .btn.found { background: #198754; }
            .footer-note {
                text-align: center;
                margin-top: 16px;
                color: #667085;
                font-size: 0.95rem;
            }
            .reports-section h2 {
                color: #1d2939;
            }
            .reports-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
            .report-card {
                background: #fff;
                border-radius: 12px;
                border: 1px solid #e4e7ec;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
            }
            .report-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }
            .cookie-consent {
                background: #ffffff;
                border-radius: 12px;
                border: 1px solid #e4e7ec;
                padding: 18px;
                box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
                position: fixed;
                bottom: 16px;
                left: 16px;
                right: 16px;
                max-width: calc(100% - 32px);
                z-index: 1000;
            }
            .cookie-consent h2 {
                margin-top: 0;
            }
            .cookie-actions {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                margin-top: 16px;
            }
            .cookie-actions button {
                border: none;
                border-radius: 8px;
                padding: 10px 16px;
                font-weight: 700;
                cursor: pointer;
            }
            .cookie-actions button.accept {
                background: #0d6efd;
                color: #fff;
            }
            .cookie-actions button.reject {
                background: #e2e8f0;
                color: #1f2937;
            }
            .cookie-status {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                padding: 12px;
                margin-top: 12px;
            }
            .report-content {
                padding: 16px;
            }
            .report-content h3 {
                margin: 0 0 8px;
                font-size: 1.1rem;
            }
            .report-type {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: bold;
                text-transform: uppercase;
            }
            .report-type.lost {
                background: #fee2e2;
                color: #dc2626;
            }
            .report-type.found {
                background: #d1fae5;
                color: #059669;
            }
            .description {
                font-style: italic;
                color: #667085;
            }
            @media (max-width: 760px) {
                .grid { grid-template-columns: 1fr; }
                .hero h1 { font-size: 1.6rem; }
            }
        </style>
    </head>
    <body>
        <nav class="nav">
            <div class="container">
                <div class="logo">Lost & Found</div>
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/home">Home</a>
                    <a href="${pageContext.request.contextPath}/report?type=LOST">Report Lost</a>
                    <a href="${pageContext.request.contextPath}/report?type=FOUND">Report Found</a>
                </div>
            </div>
        </nav>
        <div class="wrapper">
            <div class="cookie-consent" id="cookieConsentPanel">
                <h2>Cookie consent</h2>
                <p>We use cookies to remember your submission type, session, and site preferences. Please accept or reject cookies for a better experience.</p>
                <div class="cookie-actions">
                    <button class="accept" onclick="setCookieConsent('accepted')">Accept Cookies</button>
                    <button class="reject" onclick="setCookieConsent('rejected')">Reject Cookies</button>
                </div>
            </div>
            <div class="reports-section">
                <h2 style="text-align: center; margin: 20px 0 12px;">Lost Items</h2>
                <p style="text-align: center; color: #667085; margin: 0 0 24px;">Browse all lost items that have been reported.</p>
                <div class="reports-grid">
                    <%
                        String error = (String) request.getAttribute("reportError");
                        if (error != null) {
                    %>
                    <p style="text-align: center; color: #dc2626; grid-column: 1 / -1;"><%= error %></p>
                    <%
                        } else {
                            List<ReportBean> reports = (List<ReportBean>) request.getAttribute("recentLostReports");
                            if (reports == null || reports.isEmpty()) {
                    %>
                    <p style="text-align: center; color: #667085; grid-column: 1 / -1;">No lost items have been reported yet.</p>
                    <%
                            } else {
                                for (ReportBean report : reports) {
                    %>
                    <div class="report-card">
                        <% if (report.getImageFileName() != null && !report.getImageFileName().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/uploads/<%= report.getImageFileName() %>" alt="<%= report.getItemName() %>" class="report-image">
                        <% } %>
                        <div class="report-content">
                            <h3><%= report.getItemName() %></h3>
                            <p class="report-type <%= report.getReportType().toLowerCase() %>"><%= report.getReportType() %></p>
                            <p><strong>Category:</strong> <%= report.getCategory() %></p>
                            <p><strong>Location:</strong> <%= report.getLocation() %></p>
                            <p><strong>Date:</strong> <%= report.getEventDate() %></p>
                            <p class="description"><%= report.getDescription() %></p>
                            <p><strong>Contact:</strong> <%= report.getContactEmail() %> | <%= report.getContactPhone() %></p>
                        </div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                </div>
            </div>

            <div class="reports-section">
                <h2 style="text-align: center; margin: 40px 0 20px;">Found Items</h2>
                <p style="text-align: center; color: #667085; margin: 0 0 24px;">Browse all found items that have been reported.</p>
                <div class="reports-grid">
                    <%
                        if (request.getAttribute("reportError") == null) {
                            List<ReportBean> foundReports = (List<ReportBean>) request.getAttribute("recentFoundReports");
                            if (foundReports == null || foundReports.isEmpty()) {
                    %>
                    <p style="text-align: center; color: #667085; grid-column: 1 / -1;">No found items have been reported yet.</p>
                    <%
                            } else {
                                for (ReportBean report : foundReports) {
                    %>
                    <div class="report-card">
                        <% if (report.getImageFileName() != null && !report.getImageFileName().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/uploads/<%= report.getImageFileName() %>" alt="<%= report.getItemName() %>" class="report-image">
                        <% } %>
                        <div class="report-content">
                            <h3><%= report.getItemName() %></h3>
                            <p class="report-type <%= report.getReportType().toLowerCase() %>"><%= report.getReportType() %></p>
                            <p><strong>Category:</strong> <%= report.getCategory() %></p>
                            <p><strong>Location:</strong> <%= report.getLocation() %></p>
                            <p><strong>Date:</strong> <%= report.getEventDate() %></p>
                            <p class="description"><%= report.getDescription() %></p>
                            <p><strong>Contact:</strong> <%= report.getContactEmail() %> | <%= report.getContactPhone() %></p>
                        </div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                </div>
            </div>
        </div>
        <script>
            function getCookie(name) {
                const match = document.cookie.match('(^|;)\\s*' + name + '\\s*=\\s*([^;]+)');
                return match ? decodeURIComponent(match.pop()) : '';
            }
            function setCookieConsent(value) {
                const path = '<%= request.getContextPath() %>' || '/';
                document.cookie = 'cookieConsent=' + encodeURIComponent(value) + '; path=' + path + '; max-age=' + (60 * 60 * 24 * 365);
                const panel = document.getElementById('cookieConsentPanel');
                if (panel) {
                    panel.style.display = 'none';
                }
            }
            function updateConsentStatus() {
                const status = getCookie('cookieConsent');
                const panel = document.getElementById('cookieConsentPanel');
                if (status && panel) {
                    panel.style.display = 'none';
                }
            }
            window.addEventListener('load', updateConsentStatus);
        </script>
    </body>
</html>
