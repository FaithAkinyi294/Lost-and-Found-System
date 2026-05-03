package dao;

import beans.ReportBean;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;

public final class MyDaoSQL {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/report?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "Bullim@24";

    private MyDaoSQL() {
        // Utility class
    }

    public static Connection getConnection(ServletContext context) throws SQLException, ClassNotFoundException {
        loadDriver();
        String url = getConfigValue(context, "LOST_FOUND_DB_URL", "db.url", DEFAULT_URL);
        String user = getConfigValue(context, "LOST_FOUND_DB_USER", "db.user", DEFAULT_USER);
        String password = getConfigValue(context, "LOST_FOUND_DB_PASSWORD", "db.password", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, user, password);
    }

    private static void loadDriver() throws ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
    }

    private static String getConfigValue(ServletContext context, String envName, String paramName, String defaultValue) {
        String envValue = System.getenv(envName);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }
        String contextValue = context.getInitParameter(paramName);
        if (contextValue != null && !contextValue.isBlank()) {
            return contextValue.trim();
        }
        return defaultValue;
    }

    public static List<ReportBean> getRecentLostReports(ServletContext context, int limit) throws SQLException, ClassNotFoundException {
        return getRecentReportsByType(context, "LOST", limit);
    }

    public static List<ReportBean> getRecentFoundReports(ServletContext context, int limit) throws SQLException, ClassNotFoundException {
        return getRecentReportsByType(context, "FOUND", limit);
    }

    private static List<ReportBean> getRecentReportsByType(ServletContext context, String reportType, int limit) throws SQLException, ClassNotFoundException {
        String sql = "SELECT report_id, report_type, item_name, category, description, location, event_date, contact_email, contact_phone, image_file_name, created_at FROM reports WHERE report_type = ? ORDER BY created_at DESC LIMIT ?";
        List<ReportBean> reports = new ArrayList<>();
        try (Connection connection = getConnection(context);
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, reportType);
            statement.setInt(2, limit);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    ReportBean report = new ReportBean();
                    report.setReportId(rs.getLong("report_id"));
                    report.setReportType(rs.getString("report_type"));
                    report.setItemName(rs.getString("item_name"));
                    report.setCategory(rs.getString("category"));
                    report.setDescription(rs.getString("description"));
                    report.setLocation(rs.getString("location"));
                    report.setEventDate(rs.getString("event_date"));
                    report.setContactEmail(rs.getString("contact_email"));
                    report.setContactPhone(rs.getString("contact_phone"));
                    report.setImageFileName(rs.getString("image_file_name"));
                    report.setCreatedAt(rs.getString("created_at"));
                    reports.add(report);
                }
            }
        }
        return reports;
    }
}
