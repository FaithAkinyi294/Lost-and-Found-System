<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
  String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Report Lost Item</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f7fafc; color: #111827; padding: 24px; }
    .container { max-width: 760px; margin: 0 auto; }
    .card { background: #ffffff; border-radius: 18px; padding: 28px; box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08); }
    h1 { font-size: 28px; margin-bottom: 8px; }
    .subtitle { color: #6b7280; margin-bottom: 20px; }
    .form-group { margin-bottom: 18px; }
    label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; }
    input[type=text], input[type=date], select, textarea { width: 100%; padding: 12px 14px; border: 1px solid #d1d5db; border-radius: 12px; font-size: 14px; }
    textarea { min-height: 120px; resize: vertical; }
    input:focus, textarea:focus, select:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    input.error, textarea.error, select.error { border-color: #b91c1c; }
    .error-msg { color: #b91c1c; font-size: 13px; margin-top: 6px; }
    .success-msg { background: #ecfdf5; color: #166534; border: 1px solid #bbf7d0; padding: 14px 16px; border-radius: 12px; margin-bottom: 20px; }
    button { width: 100%; padding: 14px 16px; background: #2563eb; color: white; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; }
    button:hover { background: #1d4ed8; }
    button:disabled { background: #9ca3af; cursor: not-allowed; }
    .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    @media (max-width: 640px) { .grid-2 { grid-template-columns: 1fr; } }
  </style>
</head>
<body>
  <div class="container">
    <div class="card">
      <h1>Report Lost Item</h1>
      <p class="subtitle">Fill in the details about your lost item so others can help you find it.</p>

      <c:if test="${not empty successMessage}">
        <div class="success-msg">${successMessage}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/reportLost" method="post" enctype="multipart/form-data">
        <!-- Item Name -->
        <div class="form-group">
          <label for="itemName">Item Name *</label>
          <input
            id="itemName"
            type="text"
            name="itemName"
            maxlength="100"
            placeholder="e.g. Black Laptop Bag"
            value="${fn:escapeXml(param.itemName)}"
            class="${not empty errors.itemName ? 'error' : ''}"
          />
          <c:if test="${not empty errors.itemName}">
            <div class="error-msg">${errors.itemName}</div>
          </c:if>
        </div>

        <!-- Description -->
        <div class="form-group">
          <label for="description">Description *</label>
          <textarea
            id="description"
            name="description"
            maxlength="500"
            placeholder="Color, brand, unique features... (min 10 characters)"
            class="${not empty errors.description ? 'error' : ''}"
          >${fn:escapeXml(param.description)}</textarea>
          <c:if test="${not empty errors.description}">
            <div class="error-msg">${errors.description}</div>
          </c:if>
        </div>

        <!-- Category & Date -->
        <div class="grid-2">
          <div class="form-group">
            <label for="category">Category *</label>
            <select
              id="category"
              name="category"
              class="${not empty errors.category ? 'error' : ''}"
            >
              <option value="" ${empty param.category ? 'selected' : ''}>Select category</option>
              <option value="ID" ${param.category == 'ID' ? 'selected' : ''}>ID</option>
              <option value="Electronics" ${param.category == 'Electronics' ? 'selected' : ''}>Electronics</option>
              <option value="Books" ${param.category == 'Books' ? 'selected' : ''}>Books</option>
              <option value="Bags" ${param.category == 'Bags' ? 'selected' : ''}>Bags</option>
              <option value="Others" ${param.category == 'Others' ? 'selected' : ''}>Others</option>
            </select>
            <c:if test="${not empty errors.category}">
              <div class="error-msg">${errors.category}</div>
            </c:if>
          </div>

          <div class="form-group">
            <label for="dateLost">Date Lost *</label>
            <input
              id="dateLost"
              type="date"
              name="dateLost"
              max="<%= today %>"
              value="${param.dateLost}"
              class="${not empty errors.dateLost ? 'error' : ''}"
            />
            <c:if test="${not empty errors.dateLost}">
              <div class="error-msg">${errors.dateLost}</div>
            </c:if>
          </div>
        </div>

        <!-- Location -->
        <div class="form-group">
          <label for="location">Location Lost *</label>
          <input
            id="location"
            type="text"
            name="location"
            maxlength="200"
            placeholder="e.g. Library, Building A"
            value="${fn:escapeXml(param.location)}"
            class="${not empty errors.location ? 'error' : ''}"
          />
          <c:if test="${not empty errors.location}">
            <div class="error-msg">${errors.location}</div>
          </c:if>
        </div>

        <!-- Image Upload -->
        <div class="form-group">
          <label for="image">Upload Image (JPG, PNG — max 5MB)</label>
          <input
            id="image"
            type="file"
            name="image"
            accept="image/jpeg,image/png,image/gif,image/webp"
            class="${not empty errors.image ? 'error' : ''}"
          />
          <c:if test="${not empty errors.image}">
            <div class="error-msg">${errors.image}</div>
          </c:if>
        </div>

        <!-- Contact -->
        <div class="form-group">
          <label for="contact">Contact Information *</label>
          <input
            id="contact"
            type="text"
            name="contact"
            maxlength="255"
            placeholder="Email or phone number"
            value="${fn:escapeXml(param.contact)}"
            class="${not empty errors.contact ? 'error' : ''}"
          />
          <c:if test="${not empty errors.contact}">
            <div class="error-msg">${errors.contact}</div>
          </c:if>
        </div>

        <!-- Submit -->
        <button type="submit">Submit Report</button>
      </form>
    </div>
  </div>
</body>
</html>