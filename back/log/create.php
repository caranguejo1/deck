<?php

// Pegando arquivo que contém conexão com banco de dados
require "../conn.php";

// Pegando dados enviados via POST
$dados = json_decode(file_get_contents('php://input'), true);

// Validando se os dados foram enviados corretamente
if (empty($dados) || !is_array($dados) || $dados == NULL) {
    $response['status'] = 400;
    $response['ok'] = false;
    $response['message'] = 'Nenhum dado foi enviado.';
} else {
    // Identificando dados faltantes
    $missingFields = validateRequiredKeys($dados, ['numeroregistros']);
    if (!empty($missingFields)) {
        $response['status'] = 400;
        $response['ok'] = false;
        $response['message'] = 'Há dados faltantes.';
        // Configurando resposta detalhada
        $detailedMissingFields = [];
        foreach ($missingFields as $field) {
            $detailedMissingFields[$field] = "Dado não informado.";
        }
        $response['details'] = $detailedMissingFields;
    }
}

// Se há dados faltantes, retornar erro e mensagem
if ($response['ok']) {
    // Se não há dados faltantes, continuar
    try {
        // Definindo SQL para inserir dados no banco
        $sql = "INSERT INTO log (numeroregistros) VALUES (:numeroregistros)";

        // Preparando consulta
        $query = $dbConnection->prepare($sql);

        // Executando query
        if ($query->execute($dados)) {
            $response['status'] = 201;
            $response['ok'] = true;
            $response['message'] = 'Log criado com sucesso.';
        } else {
            $response['status'] = 500;
            $response['ok'] = false;
            $response['message'] = 'Log não inserido';
            $response['error'] = $dbConnection->errorInfo();
        }
    } catch (PDOException $error) {
        $response['status'] = 500;
        $response['ok'] = false;
        $response['message'] = 'Houve um erro ao registrar log';
        $response['error'] = $error->getMessage();
    }
}

// Configurando o header de resposta e retornando o resultado
header('Content-Type: application/json');
echo json_encode($response);

?>