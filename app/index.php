<?php
$counterFile = '/tmp/counter.txt';

if (!file_exists($counterFile)) {
    file_put_contents($counterFile, '0');
}

$counter = (int)file_get_contents($counterFile);
$counter++;
file_put_contents($counterFile, $counter);

$hostname = gethostname();
$phpVersion = phpversion();
$currentTime = date('Y-m-d H:i:s');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>App PHP - Desafio DotGroupo status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border: 1px solid #ddd;
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f9f9f9;
            font-weight: bold;
            width: 40%;
        }
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Status da aplicação</h1>
        
        <table>
            <tr>
                <th>Container Hostname</th>
                <td><?php echo htmlspecialchars($hostname); ?></td>
            </tr>
            <tr>
                <th>PHP Version</th>
                <td><?php echo htmlspecialchars($phpVersion); ?></td>
            </tr>
            <tr>
                <th>Server Time</th>
                <td><?php echo htmlspecialchars($currentTime); ?></td>
            </tr>
            <tr>
                <th>Request Counter</th>
                <td><?php echo htmlspecialchars($counter); ?></td>
            </tr>
        </table>
        
        <div class="footer">
            Container running successfully
        </div>
    </div>
</body>
</html>