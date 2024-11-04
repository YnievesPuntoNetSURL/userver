<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Info</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        .phpinfo-content {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            overflow-x: auto;
        }

        .phpinfo-table {
            width: 100%;
            overflow-x: auto;
        }

        .phpinfo {
            width: 100%;
            border-collapse: collapse;
        }

        .phpinfo th {
            background-color: #3B82F6;
            color: white;
            padding: 8px;
            text-align: left;
        }

        .phpinfo td {
            border: 1px solid #E5E7EB;
            padding: 8px;
        }
    </style>
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

    <div class="flex-grow flex justify-center items-center p-4 m-4">
        <div class="w-full max-w-4xl phpinfo-content shadow-md">
            <?php
            ob_start();
            phpinfo();
            $phpinfo = ob_get_clean();

            $phpinfo = preg_replace('%<style type="text/css">.*?</style>%s', '', $phpinfo);

            echo $phpinfo;
            ?>
        </div>
    </div>

    <footer class="bg-gray-800 text-white py-4 text-center">
        <p>&copy; 2007-<?php echo date("Y"); ?> YnievesPuntoNet S.U.R.L.</p>
    </footer>
</body>

</html>