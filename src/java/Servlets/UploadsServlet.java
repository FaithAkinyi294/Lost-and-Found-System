package Servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UploadsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.contains("..")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = Paths.get(pathInfo).getFileName().toString();
        File uploadDir = getUploadDirectory(request.getServletContext());
        File requestedFile = new File(uploadDir, fileName);

        if (!requestedFile.exists() || !requestedFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = getServletContext().getMimeType(requestedFile.getName());
        if (mimeType == null) {
            mimeType = Files.probeContentType(requestedFile.toPath());
        }
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setContentLengthLong(requestedFile.length());
        response.setHeader("Cache-Control", "public, max-age=86400");
        Files.copy(requestedFile.toPath(), response.getOutputStream());
    }

    private File getUploadDirectory(ServletContext context) {
        String uploadPath = context.getRealPath("/uploads");
        if (uploadPath == null) {
            uploadPath = System.getProperty("java.io.tmpdir") + File.separator + "lost_found_uploads";
        }
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        return uploadDir;
    }
}
