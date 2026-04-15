<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String type = request.getParameter("type");
    if (!"FOUND".equalsIgnoreCase(type)) {
        type = "LOST";
    } else {
        type = "FOUND";
    }
    String label = "FOUND".equals(type) ? "Found" : "Lost";
    session.removeAttribute("feedbackType");
    session.removeAttribute("feedbackMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Submission Successful</title>
        <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #eef2f7; color: #1f2a37; }
            .container { max-width: 680px; margin: 28px auto; padding: 16px; }
            .card { background: #fff; border-radius: 14px; padding: 24px; box-shadow: 0 3px 10px rgba(0,0,0,.08); text-align: center; }
            .badge { display: inline-block; padding: 6px 10px; border-radius: 999px; background: #eaf9ef; border: 1px solid #b7ebc5; color: #125d2f; font-weight: 700; margin-bottom: 12px; }
            h1 { margin: 0 0 10px; }
            p { margin: 0 0 18px; color: #526170; }
            .actions { margin-top: 10px; display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
            .btn { text-decoration: none; background: #0d6efd; color: #fff; border-radius: 8px; padding: 11px 16px; display: inline-block; min-width: 220px; text-align: center; }
            .btn.secondary { background: #198754; }
            @media (max-width: 700px) { .btn { width: 100%; min-width: 0; } }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="badge">Success</div>
                <h1><%= label %> report submitted</h1>
                <p>Your report has been uploaded successfully.</p>
                <div class="actions">
                    <a class="btn" href="<%= request.getContextPath() %>/report?type=<%= type %>">Submit Another <%= label %> Report</a>
                    <a class="btn secondary" href="<%= request.getContextPath() %>/index.jsp">Back to Home</a>
                </div>
            </div>
        </div>
    </body>
</html>
