<!DOCTYPE html>
<html>
<head>
<title>Upload Lost Item</title>

<style>
body {
    font-family: Arial;
    background: #facc15;
    color: #111827;
}

.box {
    width: 400px;
    margin: auto;
    margin-top: 50px;
    padding: 20px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
}

input, textarea {
    width: 100%;
    margin: 8px 0;
    padding: 10px;
}

button {
    width: 100%;
    padding: 10px;
    background: #4facfe;
    color: white;
    border: none;
    cursor: pointer;
}
</style>

</head>

<body>

<div class="box">

<h2>? Upload Lost Item</h2>

<form action="UploadLostServlet" method="post" enctype="multipart/form-data">

    <input type="text" name="item_name" placeholder="Item Name" required>

    <textarea name="description" placeholder="Description"></textarea>

    <input type="file" name="image" required>

    <button type="submit">Upload</button>

</form>

</div>

</body>
</html>