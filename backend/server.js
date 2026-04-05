const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Create uploads directory if it doesn't exist
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    const uniqueName = uuidv4() + path.extname(file.originalname);
    cb(null, uniqueName);
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'));
    }
  }
});

// In-memory storage for reports (in production, use a database)
let lostReports = [];
let foundReports = [];

// Routes
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Lost and Found API is running' });
});

// Get all lost reports
app.get('/api/lost-reports', (req, res) => {
  res.json(lostReports);
});

// Get all found reports
app.get('/api/found-reports', (req, res) => {
  res.json(foundReports);
});

// Submit lost item report
app.post('/api/reportLost', upload.single('image'), (req, res) => {
  try {
    const data = req.body;

    // Validation
    const errors = {};

    const itemName = data.itemName?.trim();
    if (!itemName) {
      errors.itemName = 'Item name is required';
    } else if (itemName.length < 3) {
      errors.itemName = 'Item name must be at least 3 characters';
    } else if (itemName.length > 100) {
      errors.itemName = 'Item name must be under 100 characters';
    }

    const description = data.description?.trim();
    if (!description) {
      errors.description = 'Description is required';
    } else if (description.length < 10) {
      errors.description = 'Description must be at least 10 characters';
    } else if (description.length > 500) {
      errors.description = 'Description must be under 500 characters';
    }

    if (!data.category) {
      errors.category = 'Select a category';
    }

    if (!data.dateLost) {
      errors.dateLost = 'Date is required';
    } else if (new Date(data.dateLost) > new Date()) {
      errors.dateLost = 'Date cannot be in the future';
    }

    const location = data.location?.trim();
    if (!location) {
      errors.location = 'Location is required';
    } else if (location.length < 2) {
      errors.location = 'Location must be at least 2 characters';
    }

    const contact = data.contact?.trim();
    if (!contact) {
      errors.contact = 'Contact info is required';
    } else if (!isValidContact(contact)) {
      errors.contact = 'Enter a valid email or phone number';
    }

    // Check for validation errors
    if (Object.keys(errors).length > 0) {
      return res.status(400).json({
        success: false,
        errors: errors,
        message: 'Please correct the errors below'
      });
    }

    // Create report object
    const report = {
      id: uuidv4(),
      itemName: itemName.trim(),
      description: description.trim(),
      category,
      dateLost,
      location: location.trim(),
      contact: contact.trim(),
      image: req.file ? `/uploads/${req.file.filename}` : null,
      submittedAt: new Date().toISOString(),
      status: 'active'
    };

    // Save to in-memory storage
    lostReports.push(report);

    console.log('New lost item report submitted:', report);

    res.json({
      success: true,
      message: 'Lost item report submitted successfully!',
      reportId: report.id
    });

  } catch (error) {
    console.error('Error processing lost item report:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error. Please try again.'
    });
  }
});

// Submit found item report
app.post('/api/reportFound', upload.single('image'), (req, res) => {
  try {
    const data = req.body;

    // Validation
    const errors = {};

    const itemName = data.itemName?.trim();
    if (!itemName) {
      errors.itemName = 'Item name is required';
    } else if (itemName.length < 3) {
      errors.itemName = 'Item name must be at least 3 characters';
    } else if (itemName.length > 100) {
      errors.itemName = 'Item name must be under 100 characters';
    }

    const description = data.description?.trim();
    if (!description) {
      errors.description = 'Description is required';
    } else if (description.length < 10) {
      errors.description = 'Description must be at least 10 characters';
    } else if (description.length > 500) {
      errors.description = 'Description must be under 500 characters';
    }

    if (!data.category) {
      errors.category = 'Select a category';
    }

    if (!data.dateFound) {
      errors.dateFound = 'Date is required';
    } else if (new Date(data.dateFound) > new Date()) {
      errors.dateFound = 'Date cannot be in the future';
    }

    const locationFound = data.locationFound?.trim();
    if (!locationFound) {
      errors.locationFound = 'Location found is required';
    } else if (locationFound.length < 2) {
      errors.locationFound = 'Location must be at least 2 characters';
    }

    const contact = data.contact?.trim();
    if (!contact) {
      errors.contact = 'Contact info is required';
    } else if (!isValidContact(contact)) {
      errors.contact = 'Enter a valid email or phone number';
    }

    // Check for validation errors
    if (Object.keys(errors).length > 0) {
      return res.status(400).json({
        success: false,
        errors: errors,
        message: 'Please correct the errors below'
      });
    }

    // Create report object
    const report = {
      id: uuidv4(),
      itemName: itemName.trim(),
      description: description.trim(),
      category,
      dateFound,
      locationFound: locationFound.trim(),
      dropoff: dropoff ? dropoff.trim() : null,
      contact: contact.trim(),
      image: req.file ? `/uploads/${req.file.filename}` : null,
      submittedAt: new Date().toISOString(),
      status: 'active'
    };

    // Save to in-memory storage
    foundReports.push(report);

    console.log('New found item report submitted:', report);

    res.json({
      success: true,
      message: 'Found item report submitted successfully!',
      reportId: report.id
    });

  } catch (error) {
    console.error('Error processing found item report:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error. Please try again.'
    });
  }
});

// Serve uploaded images
app.use('/uploads', express.static(uploadsDir));

// Error handling middleware
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        errors: { image: 'File too large. Maximum size is 5MB.' }
      });
    }
  }

  if (error.message === 'Only image files are allowed!') {
    return res.status(400).json({
      success: false,
      errors: { image: 'Only image files (JPG, PNG, GIF, WebP) are allowed.' }
    });
  }

  console.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    message: 'Internal server error'
  });
});

// Helper function for contact validation
function isValidContact(contact) {
  if (contact.includes('@')) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contact);
  }
  return /^\+?[\d\s\-()]{7,15}$/.test(contact);
}

app.listen(PORT, () => {
  console.log(`Lost and Found API server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
});