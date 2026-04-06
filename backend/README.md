# Lost and Found JSP Application

This is a Java web application using JSP (JavaServer Pages) for the report lost and found pages.

## Project Structure

```
jsp-webapp/
├── pom.xml
└── src
    └── main
        ├── java
        │   └── com
        │       └── example
        │           └── servlet
        │               └── ReportServlet.java
        └── webapp
            ├── ReportLost.jsp
            ├── ReportFound.jsp
            └── WEB-INF
                └── web.xml
```

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- Apache Tomcat 10+ (or any Jakarta EE compatible servlet container)

## Build and Deploy

1. **Build the WAR file:**
   ```bash
   cd jsp-webapp
   mvn clean package
   ```

2. **Deploy to Tomcat:**
   - Copy the generated `target/lost-and-found-jsp-1.0-SNAPSHOT.war` to Tomcat's `webapps` directory
   - Or use Tomcat Manager to deploy the WAR file

3. **Access the application:**
   - Open browser to `http://localhost:8080/lost-and-found-jsp-1.0-SNAPSHOT/`
   - Or `http://localhost:8080/lost-and-found-jsp-1.0-SNAPSHOT/ReportLost.jsp`
   - Or `http://localhost:8080/lost-and-found-jsp-1.0-SNAPSHOT/ReportFound.jsp`

## Features

- **ReportLost.jsp**: Form to report lost items with validation
- **ReportFound.jsp**: Form to report found items with validation
- **ReportServlet.java**: Handles form submission, validation, and error handling
- Client-side validation with server-side fallback
- File upload support for images
- Responsive design with CSS

## Form Validation

The forms include validation for:
- Required fields
- Minimum/maximum lengths
- Date validation (no future dates)
- Email/phone format validation
- Image file type and size validation

## Notes

- This is a basic example without database persistence
- In production, you would add database storage and proper error handling
- The forms currently just display success messages on valid submission