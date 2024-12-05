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
    $missingFields = validateRequiredKeys($dados, ['deck_id', 'remaining', 'shuffled', 'success']);
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
        $sql = "INSERT INTO decks (deck_id, name, remaining, shuffled, success) VALUES (:deck_id, :name,  :remaining, :shuffled, :success)";

        // Preparando consulta
        $query = $dbConnection->prepare($sql);

        // Bind dos parâmetros
        $query->bindParam(':deck_id', $dados['deck_id'], PDO::PARAM_STR);
        if (!isset($dados['name'])) $dados['name'] = NULL;
        $query->bindParam(':name', $dados['name'], PDO::PARAM_STR);
        $query->bindParam(':remaining', $dados['remaining'], PDO::PARAM_INT);
        $query->bindParam(':shuffled', $dados['shuffled'], PDO::PARAM_BOOL);
        $query->bindParam(':success', $dados['success'], PDO::PARAM_BOOL);

        // Executando query
        if ($query->execute()) {
            $response['status'] = 201;
            $response['ok'] = true;
            $response['message'] = 'Deck registrado com sucesso.';
        } else {
            $response['status'] = 500;
            $response['ok'] = false;
            $response['message'] = 'Erro ao inserir o deck.';
            $response['error'] = $dbConnection->errorInfo();
        }
    } catch (PDOException $error) {
        $response['status'] = 500;
        $response['ok'] = false;
        $response['message'] = 'Houve um erro ao registrar o deck.';
        $response['error'] = $error->getMessage();
    }
}

// Configurando o header de resposta e retornando o resultado
header('Content-Type: application/json');
echo json_encode($response);

?>
