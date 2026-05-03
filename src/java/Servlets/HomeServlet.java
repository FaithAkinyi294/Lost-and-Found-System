package Servlets;

import beans.ReportBean;
import dao.MyDaoSQL;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HomeServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            boolean foundVisitCookie = false;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("lostFoundVisit".equals(cookie.getName())) {
                        foundVisitCookie = true;
                        break;
                    }
                }
            }
            if (!foundVisitCookie) {
                Cookie visitCookie = new Cookie("lostFoundVisit", String.valueOf(System.currentTimeMillis()));
                visitCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                visitCookie.setMaxAge(60 * 60 * 24 * 30);
                response.addCookie(visitCookie);
            }

            List<ReportBean> lostReports = MyDaoSQL.getRecentLostReports(getServletContext(), 20);
            List<ReportBean> foundReports = MyDaoSQL.getRecentFoundReports(getServletContext(), 20);
            request.setAttribute("recentLostReports", lostReports);
            request.setAttribute("recentFoundReports", foundReports);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load recent reports", ex);
            request.setAttribute("reportError", "Unable to load reports at this time.");
        }
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}