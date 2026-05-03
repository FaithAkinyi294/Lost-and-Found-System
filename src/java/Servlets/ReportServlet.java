package Servlets;

import beans.ReportBean;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import dao.MyDaoSQL;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ReportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReportServlet.class.getName());
    private static final List<String> CATEGORIES = Arrays.asList(
            "Electronics", "Documents", "Bags", "Clothing", "Keys", "Accessories", "Other"
    );
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+()\\-\\s]{7,20}$");
    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
            "image/jpeg", "image/png", "image/gif", "image/webp"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = safe(request.getParameter("type")).toUpperCase();
        if (!"FOUND".equals(type)) {
            type = "LOST";
        }
        request.setAttribute("categories", CATEGORIES);
        request.getRequestDispatcher(viewByType(type)).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            ReportBean form = new ReportBean();
            form.setReportType(safe(request.getParameter("reportType")).toUpperCase());
            form.setItemName(safe(request.getParameter("itemName")));
            form.setCategory(safe(request.getParameter("category")));
            form.setDescription(safe(request.getParameter("description")));
            form.setLocation(safe(request.getParameter("location")));
            form.setEventDate(safe(request.getParameter("eventDate")));
            form.setContactEmail(safe(request.getParameter("contactEmail")));
            form.setContactPhone(safe(request.getParameter("contactPhone")));

            if (!"FOUND".equals(form.getReportType())) {
                form.setReportType("LOST");
            }

            Map<String, String> errors = validate(form);
            Part imagePart = request.getPart("itemImage");
            String imageFileName = validateAndStoreImage(request, imagePart, errors);
            form.setImageFileName(imageFileName);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("form", form);
                request.setAttribute("categories", CATEGORIES);
                request.getRequestDispatcher(viewByType(form.getReportType())).forward(request, response);
                return;
            }

            String dbError = saveReport(form);
            if (dbError != null) {
                errors.put("database", dbError);
                request.setAttribute("errors", errors);
                request.setAttribute("form", form);
                request.setAttribute("categories", CATEGORIES);
                request.getRequestDispatcher(viewByType(form.getReportType())).forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("lastReport", form);

            Cookie cookie = new Cookie("lastReportType", form.getReportType());
            cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            cookie.setMaxAge(60 * 60 * 24 * 7);
            response.addCookie(cookie);

            response.sendRedirect(request.getContextPath() + "/success.jsp?type=" + form.getReportType());
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error in doPost", ex);
            Map<String, String> errors = new HashMap<>();
            errors.put("general", "An unexpected error occurred: " + ex.getMessage());
            request.setAttribute("errors", errors);
            request.setAttribute("categories", CATEGORIES);
            String type = safe(request.getParameter("reportType")).toUpperCase();
            if (!"FOUND".equals(type)) {
                type = "LOST";
            }
            request.getRequestDispatcher(viewByType(type)).forward(request, response);
        }
    }

    private Map<String, String> validate(ReportBean form) {
        Map<String, String> errors = new HashMap<>();

        validateLength("itemName", form.getItemName(), 3, 80, errors, "Item name must be 3-80 characters.");
        if (!CATEGORIES.contains(form.getCategory())) {
            errors.put("category", "Please select a valid category.");
        }
        validateLength("description", form.getDescription(), 10, 500, errors, "Description must be 10-500 characters.");
        validateLength("location", form.getLocation(), 3, 120, errors, "Location must be 3-120 characters.");

        if (form.getEventDate().isEmpty()) {
            errors.put("eventDate", "Date is required.");
        } else {
            try {
                LocalDate date = LocalDate.parse(form.getEventDate());
                if (date.isAfter(LocalDate.now())) {
                    errors.put("eventDate", "Date cannot be in the future.");
                }
            } catch (DateTimeParseException ex) {
                errors.put("eventDate", "Invalid date format.");
            }
        }

        if (!EMAIL_PATTERN.matcher(form.getContactEmail()).matches()) {
            errors.put("contactEmail", "Enter a valid email address.");
        }
        if (!PHONE_PATTERN.matcher(form.getContactPhone()).matches()) {
            errors.put("contactPhone", "Enter a valid phone number.");
        }

        return errors;
    }

    private void validateLength(String field, String value, int min, int max,
            Map<String, String> errors, String message) {
        if (value == null || value.length() < min || value.length() > max) {
            errors.put(field, message);
        }
    }

    private String validateAndStoreImage(HttpServletRequest request, Part imagePart, Map<String, String> errors)
            throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String submittedName = Paths.get(safe(imagePart.getSubmittedFileName())).getFileName().toString();
        String contentType = safe(imagePart.getContentType());
        long size = imagePart.getSize();

        if (!ALLOWED_IMAGE_TYPES.contains(contentType)) {
            errors.put("itemImage", "Only JPG, PNG, GIF, and WebP images are allowed.");
            return null;
        }
        if (size > 5L * 1024L * 1024L) {
            errors.put("itemImage", "Image size cannot exceed 5MB.");
            return null;
        }

        String extension = getExtension(submittedName);
        String generatedName = UUID.randomUUID().toString() + (extension.isEmpty() ? "" : "." + extension);
        File uploadDir = getUploadDirectory(request);
        imagePart.write(new File(uploadDir, generatedName).getAbsolutePath());
        return generatedName;
    }

    private File getUploadDirectory(HttpServletRequest request) throws IOException {
        String uploadPath = request.getServletContext().getRealPath("/uploads");
        if (uploadPath == null) {
            uploadPath = System.getProperty("java.io.tmpdir") + File.separator + "lost_found_uploads";
        }
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            throw new IOException("Unable to create upload directory at " + uploadDir.getAbsolutePath());
        }
        return uploadDir;
    }

    private String getExtension(String fileName) {
        int index = fileName.lastIndexOf('.');
        if (index < 0 || index == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(index + 1).toLowerCase();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private String viewByType(String type) {
        return "FOUND".equals(type) ? "/reportFound.jsp" : "/reportLost.jsp";
    }

    private String saveReport(ReportBean form) {
        String sql = "INSERT INTO reports (report_type, item_name, category, description, location, event_date, "
                + "contact_email, contact_phone, image_file_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = MyDaoSQL.getConnection(getServletContext());
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, form.getReportType());
            statement.setString(2, form.getItemName());
            statement.setString(3, form.getCategory());
            statement.setString(4, form.getDescription());
            statement.setString(5, form.getLocation());
            statement.setDate(6, Date.valueOf(LocalDate.parse(form.getEventDate())));
            statement.setString(7, form.getContactEmail());
            statement.setString(8, form.getContactPhone());
            statement.setString(9, form.getImageFileName());
            statement.executeUpdate();
            return null;
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC driver not found.", ex);
            return "MySQL JDBC driver not found. Ensure mysql-connector JAR is in project libraries.";
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to save report to database.", ex);
            return "Database error (" + ex.getErrorCode() + "/" + ex.getSQLState() + "): " + safeDbMessage(ex.getMessage());
        } catch (RuntimeException ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error while saving report.", ex);
            return "Unexpected error while saving report: " + safeDbMessage(ex.getMessage());
        }
    }

    private String safeDbMessage(String message) {
        if (message == null || message.trim().isEmpty()) {
            return "No extra details available.";
        }
        String compact = message.replace('\n', ' ').replace('\r', ' ').trim();
        return compact.length() > 220 ? compact.substring(0, 220) + "..." : compact;
    }
}
