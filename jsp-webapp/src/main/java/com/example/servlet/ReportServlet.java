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

@WebServlet(name = "ReportServlet", urlPatterns = {"/reportLost", "/reportFound"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/reportFound".equals(path)) {
            request.getRequestDispatcher("/ReportFound.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/ReportLost.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        boolean isLostReport = "/reportLost".equals(path);
        Map<String, String> errors = validate(request, isLostReport);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            dispatchToPage(request, response, isLostReport);
            return;
        }

        // In a real app, save to database here
        request.setAttribute("successMessage", isLostReport ? "Lost item reported successfully!" : "Found item reported successfully!");
        dispatchToPage(request, response, isLostReport);
    }

    private Map<String, String> validate(HttpServletRequest request, boolean isLostReport) throws ServletException, IOException {
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

        String dateValue = isLostReport ? request.getParameter("dateLost") : request.getParameter("dateFound");
        String dateField = isLostReport ? "dateLost" : "dateFound";
        if (dateValue == null || dateValue.isEmpty()) {
            errors.put(dateField, "Date is required");
        } else {
            try {
                LocalDate date = LocalDate.parse(dateValue);
                if (date.isAfter(LocalDate.now())) {
                    errors.put(dateField, "Date cannot be in the future");
                }
            } catch (Exception e) {
                errors.put(dateField, "Invalid date format");
            }
        }

        String location = trim(isLostReport ? request.getParameter("location") : request.getParameter("locationFound"));
        String locationField = isLostReport ? "location" : "locationFound";
        String locationLabel = isLostReport ? "Location lost" : "Location found";
        if (location.isEmpty()) {
            errors.put(locationField, locationLabel + " is required");
        } else if (location.length() < 2) {
            errors.put(locationField, locationLabel + " must be at least 2 characters");
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

    private void dispatchToPage(HttpServletRequest request, HttpServletResponse response, boolean isLostReport) throws ServletException, IOException {
        String destination = isLostReport ? "/ReportLost.jsp" : "/ReportFound.jsp";
        request.getRequestDispatcher(destination).forward(request, response);
    }
}