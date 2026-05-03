<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report Lost Item</title>
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
            :root { color-scheme: light; }
            body { margin: 0; font-family: Arial, sans-serif; background: #f4f6f9; color: #222; }
            .container { max-width: 760px; margin: 24px auto; padding: 16px; }
            .card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.08); }
            h1 { margin-top: 0; font-size: 1.6rem; }
            .hint { margin-top: -6px; color: #5b6470; font-size: .95rem; }
            .row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
            .field { margin-bottom: 12px; display: flex; flex-direction: column; }
            label { font-weight: 700; margin-bottom: 6px; }
            input, textarea, select, button { font: inherit; }
            input, textarea, select { border: 1px solid #cfd6dd; border-radius: 8px; padding: 10px; }
            textarea { resize: vertical; min-height: 100px; }
            .msg { margin: 10px 0; padding: 10px 12px; border-radius: 8px; }
            .msg.success { background: #eaf9ef; color: #125d2f; border: 1px solid #b7ebc5; }
            .msg.error { background: #ffeef0; color: #8f1d2c; border: 1px solid #ffd1d9; }
            .error-text { color: #b00020; font-size: .86rem; min-height: 1rem; margin-top: 5px; }
            .actions { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
            button { border: none; background: #0d6efd; color: #fff; padding: 10px 16px; border-radius: 8px; cursor: pointer; }
            button:hover { background: #0a58ca; }
            button[disabled] { opacity: .75; cursor: not-allowed; }
            a { color: #0d6efd; text-decoration: none; }
            @media (max-width: 700px) {
                .row { grid-template-columns: 1fr; }
                .container { margin: 8px auto; }
                .actions { flex-direction: column; align-items: stretch; }
                .actions button, .actions a { width: 100%; text-align: center; box-sizing: border-box; }
            }
        </style>
    </head>
    <body>
        <nav class="nav">
            <div class="container">
                <div class="logo">Lost & Found</div>
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/">Home</a>
                    <a href="${pageContext.request.contextPath}/report?type=LOST">Report Lost</a>
                    <a href="${pageContext.request.contextPath}/report?type=FOUND">Report Found</a>
                </div>
            </div>
        </nav>
        <div class="container">
            <div class="card">
                <h1>Report Lost Item</h1>
                <p class="hint">Submit details to help others identify your missing item.</p>
                <% if (request.getAttribute("errors") != null) {
                        java.util.Map errors = (java.util.Map) request.getAttribute("errors");
                        if (errors.get("database") != null) {
                %>
                    <div class="msg error"><%= errors.get("database") %></div>
                <% }
                        if (errors.get("general") != null) {
                %>
                    <div class="msg error"><%= errors.get("general") %></div>
                <% }
                    }
                %>

                <form id="lostForm" action="${pageContext.request.contextPath}/report" method="post" enctype="multipart/form-data" novalidate>
                    <input type="hidden" name="reportType" value="LOST">
                    <div class="row">
                        <div class="field">
                            <label for="itemName">Item Name *</label>
                            <input id="itemName" name="itemName" value="${requestScope.form.itemName}" minlength="3" maxlength="80" required>
                            <div class="error-text" data-error-for="itemName">${requestScope.errors.itemName}</div>
                        </div>
                        <div class="field">
                            <label for="category">Category *</label>
                            <select id="category" name="category" required>
                                <option value="">Select category</option>
                                <%
                                    List<String> categories = (List<String>) request.getAttribute("categories");
                                    beans.ReportBean form = (beans.ReportBean) request.getAttribute("form");
                                    String selectedCategory = form != null ? form.getCategory() : "";
                                    if (categories != null) {
                                        for (String cat : categories) {
                                            String selectedAttr = cat.equals(selectedCategory) ? "selected" : "";
                                %>
                                    <option value="<%= cat %>" <%= selectedAttr %>><%= cat %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <div class="error-text" data-error-for="category">${requestScope.errors.category}</div>
                        </div>
                    </div>

                    <div class="field">
                        <label for="description">Description *</label>
                        <textarea id="description" name="description" minlength="10" maxlength="500" required>${requestScope.form.description}</textarea>
                        <div class="error-text" data-error-for="description">${requestScope.errors.description}</div>
                    </div>

                    <div class="row">
                        <div class="field">
                            <label for="location">Last Seen Location *</label>
                            <input id="location" name="location" value="${requestScope.form.location}" minlength="3" maxlength="120" required>
                            <div class="error-text" data-error-for="location">${requestScope.errors.location}</div>
                        </div>
                        <div class="field">
                            <label for="eventDate">Date Lost *</label>
                            <input id="eventDate" type="date" name="eventDate" value="${requestScope.form.eventDate}" required>
                            <div class="error-text" data-error-for="eventDate">${requestScope.errors.eventDate}</div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="field">
                            <label for="contactEmail">Email *</label>
                            <input id="contactEmail" type="email" name="contactEmail" value="${requestScope.form.contactEmail}" maxlength="120" required>
                            <div class="error-text" data-error-for="contactEmail">${requestScope.errors.contactEmail}</div>
                        </div>
                        <div class="field">
                            <label for="contactPhone">Phone *</label>
                            <input id="contactPhone" name="contactPhone" value="${requestScope.form.contactPhone}" maxlength="20" required>
                            <div class="error-text" data-error-for="contactPhone">${requestScope.errors.contactPhone}</div>
                        </div>
                    </div>

                    <div class="field">
                        <label for="itemImage">Item Image (JPG, PNG, GIF, WebP up to 5MB)</label>
                        <input id="itemImage" type="file" name="itemImage" accept=".jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp">
                        <div class="error-text" data-error-for="itemImage">${requestScope.errors.itemImage}</div>
                    </div>

                    <div class="actions">
                        <button id="submitLostBtn" type="submit">Submit Lost Report</button>
                        <a href="${pageContext.request.contextPath}/index.jsp">Back Home</a>
                    </div>
                </form>
            </div>
        </div>
        <script>
            (function () {
                const form = document.getElementById("lostForm");
                const submitBtn = document.getElementById("submitLostBtn");
                const defaultSubmitText = submitBtn.textContent;
                const maxImageSize = 5 * 1024 * 1024;
                const allowedTypes = ["image/jpeg", "image/png", "image/gif", "image/webp"];
                const phoneRegex = /^[0-9+()\-\s]{7,20}$/;

                function setError(name, message) {
                    const slot = document.querySelector('[data-error-for="' + name + '"]');
                    if (slot) {
                        slot.textContent = message || "";
                    }
                }

                function validate() {
                    let ok = true;
                    ["itemName", "category", "description", "location", "eventDate", "contactEmail", "contactPhone", "itemImage"].forEach(function (f) { setError(f, ""); });

                    const itemName = form.itemName.value.trim();
                    const category = form.category.value.trim();
                    const description = form.description.value.trim();
                    const location = form.location.value.trim();
                    const eventDate = form.eventDate.value;
                    const email = form.contactEmail.value.trim();
                    const phone = form.contactPhone.value.trim();
                    const file = form.itemImage.files[0];

                    if (itemName.length < 3 || itemName.length > 80) { setError("itemName", "Item name must be 3-80 characters."); ok = false; }
                    if (!category) { setError("category", "Please select a category."); ok = false; }
                    if (description.length < 10 || description.length > 500) { setError("description", "Description must be 10-500 characters."); ok = false; }
                    if (location.length < 3 || location.length > 120) { setError("location", "Location must be 3-120 characters."); ok = false; }
                    if (!eventDate) { setError("eventDate", "Date is required."); ok = false; }
                    else if (new Date(eventDate) > new Date()) { setError("eventDate", "Date cannot be in the future."); ok = false; }
                    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { setError("contactEmail", "Enter a valid email address."); ok = false; }
                    if (!phoneRegex.test(phone)) { setError("contactPhone", "Enter a valid phone number."); ok = false; }
                    if (file) {
                        if (!allowedTypes.includes(file.type)) { setError("itemImage", "Allowed types: JPG, PNG, GIF, WebP."); ok = false; }
                        if (file.size > maxImageSize) { setError("itemImage", "Image must not exceed 5MB."); ok = false; }
                    }
                    return ok;
                }

                form.addEventListener("input", validate);
                form.addEventListener("submit", function (e) {
                    if (!validate()) {
                        e.preventDefault();
                        submitBtn.disabled = false;
                        submitBtn.textContent = defaultSubmitText;
                        return;
                    }
                    submitBtn.disabled = true;
                    submitBtn.textContent = "Submitting...";
                });
            })();
        </script>
    </body>
</html>
