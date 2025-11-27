const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Serve static files (CSS, JS, Images) from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// For any other route, send index.html (useful for Single Page Apps)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`Murpet App listening on port ${port}`);
});