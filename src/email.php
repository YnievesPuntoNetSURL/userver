<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php';

$success = null;
$error = null;

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $sender = $_POST['sender'];
    $recipient = $_POST['recipient'];
    $subject = $_POST['subject'];
    $body = $_POST['body'];

    $mail = new PHPMailer(true);

    try {
        $mail->isSMTP();
        $mail->Host = '127.0.0.1';
        $mail->Port = 1025;
        $mail->SMTPAutoTLS = false;
        $mail->SMTPSecure = false;
        $mail->SMTPAuth = false;

        $mail->setFrom($sender);
        $mail->addAddress($recipient);

        $mail->Subject = $subject;
        $mail->Body    = $body;

        $mail->send();
        $success = 'El correo ha sido enviado';
    } catch (Exception $e) {
        $error = "El correo no pudo ser enviado. Error: {$mail->ErrorInfo}";
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Email</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100 flex flex-col min-h-screen">

    <nav class="bg-blue-500 text-white p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.html" class="text-xl font-bold hover:underline">µServer</a>
            <div class="flex space-x-4">
                <a href="index.php" class="hover:underline">phpInfo</a>
                <a href="email.php" class="hover:underline">testEmail</a>
            </div>
        </div>
    </nav>

    <div class="flex-grow flex justify-center items-center">
        <div class="w-full max-w-md bg-white p-8 rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-center mb-6">Test Email</h1>

            <?php if ($success): ?>
                <div class="bg-green-100 text-green-700 p-4 rounded-lg mb-4">
                    <?php echo $success; ?>
                </div>
            <?php elseif ($error): ?>
                <div class="bg-red-100 text-red-700 p-4 rounded-lg mb-4">
                    <?php echo $error; ?>
                </div>
            <?php endif; ?>

            <form method="post" class="space-y-4">
                <div>
                    <label for="sender" class="block text-gray-700 font-semibold">From:</label>
                    <input type="email" name="sender" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="email@domain.com">
                </div>
                <div>
                    <label for="recipient" class="block text-gray-700 font-semibold">To:</label>
                    <input type="email" name="recipient" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="email@domain.com">
                </div>
                <div>
                    <label for="subject" class="block text-gray-700 font-semibold">Subject:</label>
                    <input type="text" name="subject" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Subject of email">
                </div>
                <div>
                    <label for="body" class="block text-gray-700 font-semibold">Body:</label>
                    <textarea name="body" rows="5" required class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Write the email body here..."></textarea>
                </div>
                <div class="text-center">
                    <input type="submit" value="Send" class="w-full bg-blue-500 text-white font-semibold px-4 py-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-600">
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-4 text-center">
        <p>&copy; 2007-<?php echo date("Y"); ?> YnievesPuntoNet S.U.R.L.</p>
    </footer>
</body>

</html>