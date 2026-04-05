# Lost and Found Application

A full-stack web application for reporting lost and found items with React frontend and Node.js/Express backend.

## Features

- **Report Lost Items**: Submit detailed reports for lost items
- **Report Found Items**: Submit reports for items you've found
- **Image Upload**: Support for uploading item photos (JPG, PNG, GIF, WebP up to 5MB)
- **Form Validation**: Client-side and server-side validation
- **Responsive Design**: Works on desktop and mobile devices
- **Real-time Feedback**: Success/error messages for form submissions

## Tech Stack

### Frontend
- React 18 with TypeScript
- Vite (build tool)
- Tailwind CSS (styling)
- Shadcn/UI components
- React Router (navigation)

### Backend
- Node.js with Express.js
- Multer (file uploads)
- CORS support
- UUID for unique IDs
- In-memory data storage (for development)

## Getting Started

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lost-and-found
   ```

2. **Install frontend dependencies**
   ```bash
   npm install
   ```

3. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   cd ..
   ```

### Running the Application

1. **Start the backend server** (in a separate terminal):
   ```bash
   cd backend
   node server.js
   ```
   The backend will run on `http://localhost:3001`

2. **Start the frontend development server** (in another terminal):
   ```bash
   npm run dev
   ```
   The frontend will run on `http://localhost:8082` (or next available port)

### Accessing the Application

- **Main Application**: http://localhost:8082
- **Report Lost Form**: http://localhost:8082/ReportLost.html
- **Report Found Form**: http://localhost:8082/ReportFound.html
- **API Health Check**: http://localhost:8082/api/health

## API Endpoints

### GET /api/health
Check if the API is running.

### POST /api/reportLost
Submit a lost item report.

**Request Body (FormData):**
- `itemName` (string, required): Name of the lost item
- `description` (string, required): Detailed description
- `category` (string, required): Category (ID, Electronics, Books, Bags, Others)
- `dateLost` (string, required): Date when item was lost (YYYY-MM-DD)
- `location` (string, required): Location where item was lost
- `contact` (string, required): Contact information (email or phone)
- `image` (file, optional): Image file (JPG, PNG, GIF, WebP, max 5MB)

### POST /api/reportFound
Submit a found item report.

**Request Body (FormData):**
- `itemName` (string, required): Name of the found item
- `description` (string, required): Detailed description
- `category` (string, required): Category (ID, Electronics, Books, Bags, Others)
- `dateFound` (string, required): Date when item was found (YYYY-MM-DD)
- `locationFound` (string, required): Location where item was found
- `dropoff` (string, optional): Drop-off location for the item
- `contact` (string, required): Contact information (email or phone)
- `image` (file, optional): Image file (JPG, PNG, GIF, WebP, max 5MB)

### GET /api/lost-reports
Get all lost item reports.

### GET /api/found-reports
Get all found item reports.

## Development

### Building for Production

```bash
npm run build
```

### Running Tests

```bash
npm test
```

### Linting

```bash
npm run lint
```

## Project Structure

```
lost-and-found/
├── backend/                 # Node.js/Express API server
│   ├── server.js           # Main server file
│   ├── package.json        # Backend dependencies
│   └── uploads/            # Uploaded images directory
├── public/                 # Static HTML forms
│   ├── ReportLost.html     # Lost item report form
│   └── ReportFound.html    # Found item report form
├── src/                    # React frontend source
│   ├── components/         # Reusable UI components
│   ├── pages/             # Page components
│   ├── lib/               # Utility functions
│   └── assets/            # Static assets
├── package.json            # Frontend dependencies
├── vite.config.ts          # Vite configuration
└── README.md              # This file
```

## Form Validation Rules

### Item Name
- Required
- 3-100 characters
- Cannot be empty or whitespace only

### Description
- Required
- 10-500 characters
- Must provide meaningful details

### Category
- Required
- Must select from predefined options

### Date
- Required
- Cannot be in the future
- Must be valid date format

### Location
- Required
- At least 2 characters
- Cannot be empty

### Contact Information
- Required
- Must be valid email format or phone number
- Email: standard email validation
- Phone: 7-15 digits with optional formatting

### Image Upload
- Optional
- Supported formats: JPG, PNG, GIF, WebP
- Maximum size: 5MB
- Server-side validation for file type and size

## Error Handling

The application provides comprehensive error handling:

- **Client-side validation**: Immediate feedback before form submission
- **Server-side validation**: Additional validation on the backend
- **Network errors**: Graceful handling of connection issues
- **File upload errors**: Specific error messages for invalid files

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
