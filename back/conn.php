<?php

// Tentativa de conexão ao banco de dados
try {
    // Estabelecendo a conexão com o banco
    $dbConnection = new PDO('mysql:host=localhost;dbname=deck;charset=utf8', 'root', '');
} catch (Exception $error) {
    // Tratamento de erro de conexão
    die('
        <div style="
            font-family: Verdana, Geneva, Tahoma, sans-serif; 
            text-align: center; 
            background-color: #ffe0e0; 
            color: #a80000; 
            padding: 20px; 
            border: 2px solid #f2b2b2; 
            border-radius: 8px; 
            margin: 20px;
        ">
            <h1 style="color: #ff4d4d;">Falha na Conexão</h1>
            <p>Não conseguimos acessar o banco de dados. Verifique as informações a seguir:</p>
            <p style="font-size: 0.9em; background: #fefefe; padding: 10px; border-radius: 6px;">Erro: ' . $error->getMessage() . '</p>
            <button style="
                margin-top: 15px; 
                padding: 12px 25px; 
                font-size: 1rem; 
                color: #ffffff; 
                background-color: #008cba; 
                border: none; 
                border-radius: 5px; 
                cursor: pointer;
            " onclick="window.location.href=\'http://localhost/gatitos\'">
                Retornar
            </button>
        </div>
    ');
}

// Alteração na variável de resposta HTTP
$response = array(
    'status' => 200,
    'message' => '',
    'ok' => true
);

// Nova versão da função para verificar chaves obrigatórias
function validateRequiredKeys(array $dataArray, array $requiredKeys)
{
    $missingKeys = [];
    foreach ($requiredKeys as $key) {
        if (empty($dataArray[$key])) {
            $missingKeys[] = $key;
        }
    }
    return $missingKeys;
}

?>
