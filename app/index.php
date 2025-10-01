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
    <title>Aplicação PHP Containerizada</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        
        h1 {
            color: #667eea;
            margin-bottom: 30px;
            text-align: center;
            font-size: 2em;
        }
        
        .info-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        
        .info-card strong {
            color: #333;
            display: block;
            margin-bottom: 5px;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .info-card span {
            color: #666;
            font-size: 1.1em;
        }
        
        .counter {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-top: 30px;
        }
        
        .counter h2 {
            font-size: 1.2em;
            margin-bottom: 10px;
            opacity: 0.9;
        }
        
        .counter .number {
            font-size: 3em;
            font-weight: bold;
        }
        
        .status {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            margin-top: 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Aplicação PHP Modernizada</h1>
        
        <div class="info-card">
            <strong>Hostname do Container</strong>
            <span><?php echo htmlspecialchars($hostname); ?></span>
        </div>
        
        <div class="info-card">
            <strong>Versão do PHP</strong>
            <span><?php echo htmlspecialchars($phpVersion); ?></span>
        </div>
        
        <div class="info-card">
            <strong>Data e Hora Atual</strong>
            <span><?php echo htmlspecialchars($currentTime); ?></span>
        </div>
        
        <div class="counter">
            <h2>Total de Visitas</h2>
            <div class="number"><?php echo htmlspecialchars($counter); ?></div>
        </div>
        
        <div class="status">
            ✅ Aplicação rodando com sucesso em ambiente containerizado!
        </div>
    </div>
</body>
</html>