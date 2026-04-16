package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/MatchServlet")
public class MatchServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/lostandfound";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Password";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ✅ Get ONLY IDs (no user details)
        String lostIdStr = req.getParameter("lost_id");
        String foundIdStr = req.getParameter("found_id");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // ✅ Validate input
            if (lostIdStr == null || foundIdStr == null) {
                res.sendRedirect("admin/error.jsp?msg=missing_ids");
                return;
            }

            int lostId = Integer.parseInt(lostIdStr);
            int foundId = Integer.parseInt(foundIdStr);

            // ✅ Load driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // ✅ Connect DB
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // ✅ Insert match
            String sql = "INSERT INTO matched_items (lost_id, found_id, match_date) VALUES (?, ?, NOW())";
            ps = con.prepareStatement(sql);

            ps.setInt(1, lostId);
            ps.setInt(2, foundId);

            int result = ps.executeUpdate();

            if (result > 0) {

                // 🔥 OPTIONAL: Update status of items
                updateItemStatus(con, lostId, foundId);

                res.sendRedirect("admin/matchSuccess.jsp");

            } else {
                res.sendRedirect("admin/error.jsp?msg=insert_failed");
            }

        } catch (NumberFormatException e) {
            res.sendRedirect("admin/error.jsp?msg=invalid_id");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("admin/error.jsp?msg=server_error");

        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ OPTIONAL METHOD (VERY IMPORTANT)
    private void updateItemStatus(Connection con, int lostId, int foundId) {
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            // Mark lost item as matched
            String sql1 = "UPDATE lost_items SET status='MATCHED' WHERE id=?";
            ps1 = con.prepareStatement(sql1);
            ps1.setInt(1, lostId);
            ps1.executeUpdate();

            // Mark found item as matched
            String sql2 = "UPDATE found_items SET status='MATCHED' WHERE id=?";
            ps2 = con.prepareStatement(sql2);
            ps2.setInt(1, foundId);
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
        }
    }
}