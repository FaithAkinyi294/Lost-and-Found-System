package com.example.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ReportFoundServlet", urlPatterns = {"/reportFound"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class ReportFoundServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        request.getRequestDispatcher("/ReportFound.jsp").forward(request, response);
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        request.setCharacterEncoding("UTF-8");

        Map<String, String> errors = validate(request);

        if (!errors.isEmpty()) {
            String json = "{\"success\": false, \"errors\": " + mapToJson(errors) + "}";
            response.getWriter().write(json);
        } else {
            // In a real app, save to database here
            String message = "Found item reported successfully!";
            String json = "{\"success\": true, \"message\": \"" + message + "\"}";
            response.getWriter().write(json);
        }
    }

    private Map<String, String> validate(HttpServletRequest request) throws ServletException, IOException {
        Map<String, String> errors = new HashMap<>();
        String itemName = trim(request.getParameter("itemName"));
        if (itemName.isEmpty()) {
            errors.put("itemName", "Item name is required");
        } else if (itemName.length() < 3) {
            errors.put("itemName", "Item name must be at least 3 characters");
        } else if (itemName.length() > 100) {
            errors.put("itemName", "Item name must be under 100 characters");
        }

        String description = trim(request.getParameter("description"));
        if (description.isEmpty()) {
            errors.put("description", "Description is required");
        } else if (!isValidDescription(description)) {
            errors.put("description", "Description must be 10-1000 characters");
        }

        String category = request.getParameter("category");
        if (category == null || category.isEmpty()) {
            errors.put("category", "Select a category");
        }

        String dateFound = request.getParameter("dateFound");
        if (dateFound == null || dateFound.isEmpty()) {
            errors.put("dateFound", "Date found is required");
        } else {
            try {
                LocalDate date = LocalDate.parse(dateFound);
                if (date.isAfter(LocalDate.now())) {
                    errors.put("dateFound", "Date cannot be in the future");
                }
            } catch (Exception e) {
                errors.put("dateFound", "Invalid date format");
            }
        }

        String locationFound = trim(request.getParameter("locationFound"));
        if (locationFound.isEmpty()) {
            errors.put("locationFound", "Location found is required");
        } else if (locationFound.length() < 2) {
            errors.put("locationFound", "Location must be at least 2 characters");
        }

        String contact = trim(request.getParameter("contact"));
        if (contact.isEmpty()) {
            errors.put("contact", "Contact info is required");
        } else if (!isValidContact(contact)) {
            errors.put("contact", "Enter a valid email or phone number");
        }

        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String imageError = validateImage(imagePart);
            if (imageError != null) {
                errors.put("image", imageError);
            }
        }
        return errors;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isValidContact(String contact) {
        if (contact.contains("@")) {
            // Email validation
            return contact.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
        } else {
            // Phone validation - allow digits, spaces, hyphens, parentheses, plus sign
            return contact.matches("^\\+?[0-9\\s\\-()]{7,20}$");
        }
    }

    private boolean isValidDescription(String description) {
        return description.length() >= 10 && description.length() <= 1000;
    }

    private String validateImage(Part imagePart) {
        String contentType = imagePart.getContentType();
        if (contentType == null) {
            return "Invalid image file";
        }

        String[] allowedTypes = {"image/jpeg", "image/png", "image/gif", "image/webp"};
        boolean validType = false;
        for (String type : allowedTypes) {
            if (type.equals(contentType)) {
                validType = true;
                break;
            }
        }
        if (!validType) {
            return "Only JPG, PNG, GIF, or WebP images are allowed";
        }
        if (imagePart.getSize() > 5L * 1024L * 1024L) {
            return "Image must be under 5MB";
        }
        return null;
    }

    private String mapToJson(Map<String, String> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            if (!first) sb.append(",");
            sb.append("\"").append(entry.getKey()).append("\": \"").append(escapeJsonString(entry.getValue())).append("\"");
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }

    private String escapeJsonString(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}